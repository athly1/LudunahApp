// HomeView.swift - main screen after onboarding.
//
// Contains:
// - Greeting, EnergyCheckInView, one card per selected interest, WeeklyProgressChart.
// - Tapping an interest opens TaskSheet.
// - Toolbar button for SettingsView.
// - Owns a HomeViewModel as @State.
//
// Used by: LudoonaApp as the root of the NavigationStack.


import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var appRouter

    @State private var energyValue = 50
    @State private var completedChallenges: Set<Int> = [1]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.space24) {

                // الإعدادات
                HStack {
                    Spacer()

                    Button {
                        appRouter.push(.settings)
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(Color.textPrimary.opacity(0.08))
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("الإعدادات")
                }

                // مستوى الطاقة
                EnergyCheckInView(
                    energyValue: $energyValue
                )

                // عنوان التحديات
                Text("تحدياتك")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)

                // التحدي الأول
                DailyChallengeCard(
                    title: "التكوين البصري الصامت",
                    category: "الفن السعودي",
                    minutes: 5,
                    isCompleted: completedChallenges.contains(1),
                    iconName: "shapes",
                    iconColor: Color.artPalette1,
                    onSwap: {},
                    onTap: {
                        completedChallenges.insert(1)
                    }
                )

                // التحدي الثاني
                DailyChallengeCard(
                    title: "خريطة اللعبة في رأسك",
                    category: "الرياضات الإلكترونية",
                    minutes: 5,
                    isCompleted: completedChallenges.contains(2),
                    iconName: "square.grid.2x2.fill",
                    iconColor: Color.mapSequers,
                    onSwap: {},
                    onTap: {
                        completedChallenges.insert(2)
                    }
                )

                // التحدي الثالث
                DailyChallengeCard(
                    title: "الجدران جزء من اللعبة",
                    category: "كرة القدم",
                    minutes: 8,
                    isCompleted: completedChallenges.contains(3),
                    iconName: "soccerball",
                    iconColor: Color.sportFieldBall,
                    onSwap: {},
                    onTap: {
                        completedChallenges.insert(3)
                    }
                )
            }
            .padding(Spacing.pageMargin)
        }
        .background(Color.pageBackground.ignoresSafeArea())
        .environment(\.layoutDirection, .rightToLeft)
        .toolbar(.hidden, for: .navigationBar)
    }
}
