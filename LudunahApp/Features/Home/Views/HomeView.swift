
import SwiftUI

struct HomeView: View {

    @Environment(AppRouter.self) private var appRouter

    @State private var energyValue = 50

    // النشاط البديل لكل بطاقة
    @State private var alternateActivities: [Int: Activity] = [:]

    // رسائل الخطأ
    @State private var showSwapError = false
    @State private var swapErrorMessage = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.space24) {

                // الإعدادات - أعلى اليمين
                HStack {
                    Button {
                        appRouter.push(.settings)
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.textPrimary)
                            .frame(width: 35, height: 44)
                            .contentShape(Circle())
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel("الإعدادات")

                    Spacer()
                }

                // مستوى الطاقة
                EnergyCheckInView(
                    energyValue: $energyValue
                )

                // عنوان التحديات
                Text("تحدياتك")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // التحدي الأول: الفن
                DailyChallengeCard(
                    title: alternateActivities[1]?.title
                        ?? "التكوين البصري الصامت",
                    category: "الفن السعودي",
                    minutes: alternateActivities[1]?.durationMin ?? 5,
                    isCompleted: appRouter.completedInterests.contains(.art),                    iconName: "ArtChallengeIcon",
                    iconBackground: Color.challengeArtBadge,
                    onSwap: {
                        swapChallenge(
                            id: 1,
                            interest: .art,
                            originalTitle: "التكوين البصري الصامت"
                        )
                    },
                    onTap: {
                        appRouter.push(.activity(.art))
                    }                )

                // التحدي الثاني: الألعاب
                DailyChallengeCard(
                    title: alternateActivities[2]?.title
                        ?? "خريطة اللعبة في رأسك",
                    category: "الرياضات الإلكترونية",
                    minutes: alternateActivities[2]?.durationMin ?? 5,
                    isCompleted: appRouter.completedInterests.contains(.gaming),                    iconName: "GamingChallengeIcon",
                    iconBackground: Color.challengeGamingBadge,
                    onSwap: {
                        swapChallenge(
                            id: 2,
                            interest: .gaming,
                            originalTitle: "خريطة اللعبة في رأسك"
                        )
                    },
                    onTap: {
                        appRouter.push(.activity(.gaming))
                    }
                )

                // التحدي الثالث: الرياضة
                DailyChallengeCard(
                    title: alternateActivities[3]?.title
                        ?? "الجدران جزء من اللعبة",
                    category: "كرة القدم",
                    minutes: alternateActivities[3]?.durationMin ?? 8,
                    isCompleted: appRouter.completedInterests.contains(.sport),                   iconName: "SportChallengeIcon",
                    iconBackground: Color.challengeSportBadge,
                    onSwap: {
                        swapChallenge(
                            id: 3,
                            interest: .sport,
                            originalTitle: "الجدران جزء من اللعبة"
                        )
                    },
                    onTap: {
                        appRouter.push(.activity(.sport))
                    }
                )
            }
            .padding(Spacing.pageMargin)
        }
        .background(Color.pageBackground.ignoresSafeArea())
        .environment(\.layoutDirection, .rightToLeft)
        .toolbar(.hidden, for: .navigationBar)

        // تحديث التحديات عند الانتقال إلى مستوى طاقة آخر
        .onChange(of: EnergyLevel.from(value: energyValue)) { _, _ in
            swapChallenge(
                id: 1,
                interest: .art,
                originalTitle: "التكوين البصري الصامت"
            )

            swapChallenge(
                id: 2,
                interest: .gaming,
                originalTitle: "خريطة اللعبة في رأسك"
            )

            swapChallenge(
                id: 3,
                interest: .sport,
                originalTitle: "الجدران جزء من اللعبة"
            )
        }

        // عرض رسائل الخطأ
        .alert(
            "تعذّر تبديل التحدي",
            isPresented: $showSwapError
        ) {
            Button("حسنًا", role: .cancel) {}
        } message: {
            Text(swapErrorMessage)
        }
    }

    // اختيار تحدٍ عشوائي من الفئة نفسها حسب مستوى الطاقة
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
            
            appRouter.resetCompletion(interest)
            
            appRouter.resetCompletion(interest)
        } catch {
            swapErrorMessage =
                "تعذّر تحميل الأنشطة. تحققي من ملفات JSON."
            showSwapError = true
        }
    }
}

#Preview {
    HomeView()
        .environment(AppRouter())
}
