
// HomeView.swift - الشاشة الرئيسية في لُدُونه.
//
// Contains:
// - Settings navigation.
// - Energy level check-in.
// - Daily challenge cards based on selected interests.
// - Challenge swapping for selected interests.
// - Instructions sheet.
// - Completion status.
//
// Used by: RootView, AppRouter.
//
// Learn: @Environment, @State, Button,
//        conditional views, overlay, onChange.

import SwiftUI

struct HomeView: View {

    // MARK: - Environment

    @Environment(AppRouter.self) private var appRouter

    // قراءة الاهتمامات المختارة من الإعدادات
    @Environment(AppState.self) private var appState

    // MARK: - State

    @State private var energyValue = 50

    // النشاط البديل لكل بطاقة
    @State private var alternateActivities: [Int: Activity] = [:]

    // التحدي الذي تم الضغط عليه
    @State private var selectedChallenge: ChallengeSheetItem?

    // رسائل الخطأ
    @State private var showSwapError = false
    @State private var swapErrorMessage = ""

    // MARK: - Body

    var body: some View {

        ScrollView {

            Spacer(minLength: -32)

            VStack(alignment: .leading, spacing: Spacing.space24) {

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
                    energyValue: $energyValue
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

                // عرض الفن فقط إذا اختاره المستخدم
                if appState.selectedInterests.contains(.art) {

                    DailyChallengeCard(
                        title: alternateActivities[1]?.title
                            ?? "التكوين البصري الصامت",

                        category: "الفن السعودي",

                        minutes: alternateActivities[1]?.durationMin ?? 5,

                        isCompleted: appRouter.completedInterests.contains(.art),

                        iconName: "artLudunah",

                        iconBackground: Color.challengeArtBadge,

                        onSwap: {
                            swapChallenge(
                                id: 1,
                                interest: .art,
                                originalTitle: "التكوين البصري الصامت"
                            )
                        },

                        onTap: {
                            showInstructions(
                                id: 1,
                                interest: .art,
                                image: "artLudunah",
                                defaultTitle: "التكوين البصري الصامت"
                            )
                        }
                    )
                }

                // MARK: - Gaming Challenge

                // عرض الألعاب فقط إذا اختارها المستخدم
                if appState.selectedInterests.contains(.gaming) {

                    DailyChallengeCard(
                        title: alternateActivities[2]?.title
                            ?? "خريطة اللعبة في رأسك",

                        category: "الرياضات الإلكترونية",

                        minutes: alternateActivities[2]?.durationMin ?? 5,

                        isCompleted: appRouter.completedInterests.contains(.gaming),

                        iconName: "GameLudunah",

                        iconBackground: Color.challengeGamingBadge,

                        onSwap: {
                            swapChallenge(
                                id: 2,
                                interest: .gaming,
                                originalTitle: "خريطة اللعبة في رأسك"
                            )
                        },

                        onTap: {
                            showInstructions(
                                id: 2,
                                interest: .gaming,
                                image: "GameLudunah",
                                defaultTitle: "خريطة اللعبة في رأسك"
                            )
                        }
                    )
                }

                // MARK: - Sport Challenge

                // عرض الرياضة فقط إذا اختارها المستخدم
                if appState.selectedInterests.contains(.sport) {

                    DailyChallengeCard(
                        title: alternateActivities[3]?.title
                            ?? "الجدران جزء من اللعبة",

                        category: "كرة القدم",

                        minutes: alternateActivities[3]?.durationMin ?? 8,

                        isCompleted: appRouter.completedInterests.contains(.sport),

                        iconName: "SportLudunah",

                        iconBackground: Color.challengeSportBadge,

                        onSwap: {
                            swapChallenge(
                                id: 3,
                                interest: .sport,
                                originalTitle: "الجدران جزء من اللعبة"
                            )
                        },

                        onTap: {
                            showInstructions(
                                id: 3,
                                interest: .sport,
                                image: "SportLudunah",
                                defaultTitle: "الجدران جزء من اللعبة"
                            )
                        }
                    )
                }

            }
            .padding(Spacing.pageMargin)
        }

        // MARK: - Design System

        .background(Color.pageBackground.ignoresSafeArea())
        .environment(\.layoutDirection, .rightToLeft)
        .toolbar(.hidden, for: .navigationBar)

        // MARK: - Energy Changes

        .onChange(
            of: EnergyLevel.from(value: energyValue)
        ) { _, _ in

            // تبديل تحديات الاهتمامات المختارة فقط

            if appState.selectedInterests.contains(.art) {

                swapChallenge(
                    id: 1,
                    interest: .art,
                    originalTitle: "التكوين البصري الصامت"
                )
            }

            if appState.selectedInterests.contains(.gaming) {

                swapChallenge(
                    id: 2,
                    interest: .gaming,
                    originalTitle: "خريطة اللعبة في رأسك"
                )
            }

            if appState.selectedInterests.contains(.sport) {

                swapChallenge(
                    id: 3,
                    interest: .sport,
                    originalTitle: "الجدران جزء من اللعبة"
                )
            }
        }

        // MARK: - Instructions Sheet

        .overlay {

            if let item = selectedChallenge {

                ZStack(alignment: .bottom) {

                    // خلفية معتمة
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
                    .containerRelativeFrame(.vertical) { height, _ in
                        height * 0.65
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

    // MARK: - Close Instructions

    private func closeInstructions() {

        withAnimation(.easeInOut(duration: 0.3)) {
            selectedChallenge = nil
        }
    }

    // MARK: - Open Instructions

    private func showInstructions(
        id: Int,
        interest: Interest,
        image: String,
        defaultTitle: String
    ) {

        withAnimation(.easeInOut(duration: 0.3)) {

            selectedChallenge = ChallengeSheetItem(
                interest: interest,
                image: image,
                activity: currentActivity(
                    id: id,
                    interest: interest,
                    defaultTitle: defaultTitle
                )
            )
        }
    }

    // MARK: - Current Activity

    private func currentActivity(
        id: Int,
        interest: Interest,
        defaultTitle: String
    ) -> Activity? {

        // 1. النشاط البديل بعد التبديل
        if let swapped = alternateActivities[id] {
            return swapped
        }

        let all = (try? ContentService.loadActivities(for: interest)) ?? []

        // 2. النشاط الافتراضي حسب العنوان
        if let match = all.first(where: { $0.title == defaultTitle }) {
            return match
        }

        // 3. أول نشاط يناسب مستوى الطاقة
        let step = EnergyLevel
            .from(value: energyValue)
            .activityStep

        return all.first(where: { $0.type == step })
    }

    // MARK: - Swap Challenge

    private func swapChallenge(
        id: Int,
        interest: Interest,
        originalTitle: String
    ) {

        let requiredStep = EnergyLevel
            .from(value: energyValue)
            .activityStep

        do {

            let activities = try ContentService
                .loadActivities(for: interest)
                .filter { $0.type == requiredStep }

            let currentTitle = alternateActivities[id]?.title
                ?? originalTitle

            let alternatives = activities.filter {
                $0.title != currentTitle
            }

            guard let selected = alternatives.randomElement() else {

                swapErrorMessage =
                    "لا يوجد تحدٍ بديل مناسب لمستوى طاقتك في هذه الفئة."

                showSwapError = true
                return
            }

            alternateActivities[id] = selected

            // إزالة الإنجاز عند تغيير التحدي
            appRouter.resetCompletion(interest)

        } catch {

            swapErrorMessage =
                "تعذّر تحميل الأنشطة. تحققي من ملفات JSON."

            showSwapError = true
        }
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
