
import SwiftUI

/// The main screen of Ludunah.
struct HomeView: View {

    // MARK: - Environment

    @Environment(AppRouter.self) private var appRouter
    @Environment(AppState.self) private var appState
    @Environment(\.scenePhase) private var scenePhase

    // MARK: - State

    @State private var viewModel = HomeViewModel()
    @State private var selectedChallenge: ChallengeSheetItem?

    @State private var showSwapError = false
    @State private var swapErrorMessage = ""

    @State private var weeklyCounts: [Int] = []

    // MARK: - Body

    var body: some View {
        @Bindable var model = viewModel

        ScrollView {
            Spacer(minLength: -32)

            VStack(
                alignment: .leading,
                spacing: Spacing.space24
            ) {

                // MARK: - Settings Button

                HStack {
                    Button {
                        appRouter.push(.settings)
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.textPrimary)
                            .frame(width: 25, height: 32)
                            .contentShape(Circle())
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel("الإعدادات")

                    Spacer()
                }

                // MARK: - Energy Check-In

                EnergyCheckInView(
                    energyValue: $model.energyValue
                )

                // MARK: - Challenges Title

                Text("تحدياتك")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                // MARK: - Art Challenge

                if appState.selectedInterests.contains(.art),
                   let activity = viewModel.activity(for: .art) {

                    DailyChallengeCard(
                        title: activity.title,
                        category: "الفن السعودي",
                        minutes: activity.durationMin ?? 5,
                        isCompleted: appRouter.completedInterests
                            .contains(.art),
                        iconName: "artLudunah",
                        iconBackground: Color.challengeArtBadge,
                        onSwap: {
                            swapChallenge(for: .art)
                        },
                        onTap: {
                            showInstructions(
                                interest: .art,
                                image: "artLudunah"
                            )
                        }
                    )
                }

                // MARK: - Gaming Challenge

                if appState.selectedInterests.contains(.gaming),
                   let activity = viewModel.activity(for: .gaming) {

                    DailyChallengeCard(
                        title: activity.title,
                        category: "الرياضات الإلكترونية",
                        minutes: activity.durationMin ?? 5,
                        isCompleted: appRouter.completedInterests
                            .contains(.gaming),
                        iconName: "GameLudunah",
                        iconBackground: Color.challengeGamingBadge,
                        onSwap: {
                            swapChallenge(for: .gaming)
                        },
                        onTap: {
                            showInstructions(
                                interest: .gaming,
                                image: "GameLudunah"
                            )
                        }
                    )
                }

                // MARK: - Sport Challenge

                if appState.selectedInterests.contains(.sport),
                   let activity = viewModel.activity(for: .sport) {

                    DailyChallengeCard(
                        title: activity.title,
                        category: "كرة القدم",
                        minutes: activity.durationMin ?? 8,
                        isCompleted: appRouter.completedInterests
                            .contains(.sport),
                        iconName: "SportLudunah",
                        iconBackground: Color.challengeSportBadge,
                        onSwap: {
                            swapChallenge(for: .sport)
                        },
                        onTap: {
                            showInstructions(
                                interest: .sport,
                                image: "SportLudunah"
                            )
                        }
                    )
                }

                // MARK: - Weekly Progress

                VStack(
                    alignment: .leading,
                    spacing: Spacing.space16
                ) {
                    Text("التقدم الأسبوعي")
                        .font(.title1Heading)
                        .foregroundStyle(Color.textPrimary)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )

                    WeeklyProgressChart(
                        counts: weeklyCounts
                    )
                }
                .padding(.top, Spacing.space16)
            }
            .padding(Spacing.pageMargin)
        }

        // MARK: - Design System

        .background(
            Color.pageBackground.ignoresSafeArea()
        )
        .environment(\.layoutDirection, .rightToLeft)
        .toolbar(.hidden, for: .navigationBar)

        // MARK: - Initial Loading

        .task {
            viewModel.loadChallenges(
                for: appState.selectedInterests
            )
            refreshWeeklyProgress()
            appRouter.refreshCompletedInterests()
        }

        // MARK: - App Becomes Active

        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                refreshWeeklyProgress()
                appRouter.refreshCompletedInterests()
            }
        }

        // MARK: - Energy Changes

        .onChange(of: viewModel.energyLevel) { _, _ in
            viewModel.loadChallenges(
                for: appState.selectedInterests
            )
        }

        // MARK: - Interest Changes

        .onChange(of: appState.selectedInterests) { _, interests in
            viewModel.loadChallenges(for: interests)
        }

        // MARK: - Instructions Sheet

        .overlay {
            if let item = selectedChallenge {
                ZStack(alignment: .bottom) {

                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .onTapGesture {
                            closeInstructions()
                        }

                    InstructionsSheet(
                        interest: item.interest,
                        InterestImage: item.image,
                        activity: item.activity,
                        onClose: {
                            closeInstructions()
                        }
                    )
                    .id(item.id)
                    .frame(maxWidth: .infinity)
                    .containerRelativeFrame(.vertical) {
                        height, _ in height * 0.65
                    }
                    .background(
                        Color.pageBackground,
                        in: UnevenRoundedRectangle(
                            topLeadingRadius: 32,
                            topTrailingRadius: 32
                        )
                    )
                    .ignoresSafeArea(edges: .bottom)
                    .transition(.move(edge: .bottom))
                }
            }
        }

        // MARK: - Error Alert

        .alert(
            "تعذّر تبديل التحدي",
            isPresented: $showSwapError
        ) {
            Button("حسنًا", role: .cancel) {}
        } message: {
            Text(swapErrorMessage)
        }
    }

    // MARK: - Weekly Progress

    private func refreshWeeklyProgress() {
        weeklyCounts = StorageService()
            .weeklyCompletedCounts()
    }

    // MARK: - Close Instructions

    private func closeInstructions() {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedChallenge = nil
        }

        refreshWeeklyProgress()
        appRouter.refreshCompletedInterests()
    }

    // MARK: - Open Instructions

    private func showInstructions(
        interest: Interest,
        image: String
    ) {
        guard let activity = viewModel.activity(for: interest) else {
            return
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            selectedChallenge = ChallengeSheetItem(
                interest: interest,
                image: image,
                activity: activity
            )
        }
    }

    // MARK: - Swap Challenge

    private func swapChallenge(for interest: Interest) {
        let didSwap = viewModel.swapChallenge(for: interest)

        guard !didSwap else { return }

        swapErrorMessage = viewModel.errorMessage
            ?? "لا يوجد تحدٍ بديل مناسب لمستوى طاقتك في هذه الفئة."

        showSwapError = true
    }
}

// MARK: - Challenge Sheet Item

struct ChallengeSheetItem: Identifiable {
    let id = UUID()
    let interest: Interest
    let image: String
    let activity: Activity?
}

// MARK: - Preview

#Preview {
    HomeView()
        .environment(AppRouter())
        .environment(AppState())
}
