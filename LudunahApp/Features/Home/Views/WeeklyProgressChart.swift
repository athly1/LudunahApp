// WeeklyProgressChart.swift - completed activities for the last 7 days.
//
// Contains:
// - A bar chart: day on the x axis, count on the y axis.
// - Input: list of day + count values from HomeViewModel.
// - Empty state when there is no progress.
//
// Used by: HomeView.
// Learn: Swift Charts (Chart, BarMark)



import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var appRouter

    @State private var viewModel = HomeViewModel()
    @State private var selectedTask: DailyTask?
    @State private var selectedStep: ActivityStep = .learn
    @State private var isTaskSheetPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.space24) {

                // الإعدادات
                HStack {
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

                    Spacer()
                }

                // قياس الطاقة
                EnergyCheckInView(
                    energyValue: $viewModel.energyValue
                )

                // عنوان التحديات
                HStack {
                    Text("تحدياتك")
                        .font(.title1Heading)
                        .foregroundStyle(Color.textPrimary)

                    Spacer()

                    Button("اقترح تحديًا") {
                        viewModel.buildTodaysTask(using: appState)

                        if let task = viewModel.currentTask {
                            selectedTask = task
                            selectedStep = viewModel.requiredActivityStep
                            isTaskSheetPresented = true
                        }
                    }
                    .font(.titleCards)
                    .foregroundStyle(Color.appSecondary)
                }

                // رسالة الخطأ عند عدم توفر نشاط
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.titleCards)
                        .foregroundStyle(Color.textPrimary)
                }

                // بطاقة النشاط المقترح
                if let task = viewModel.currentTask {
                    DailyChallengeCard(
                        title: task.title,
                        category: task.interest.title,
                        minutes: task.minutes ?? 5,
                        isCompleted: false,
                        iconName: task.interest.iconName,
                        iconColor: Color.appSecondary,
                        onSwap: {
                            viewModel.showAlternative()

                            if let updatedTask = viewModel.currentTask {
                                selectedTask = updatedTask
                                selectedStep = viewModel.requiredActivityStep
                            }
                        },
                        onTap: {
                            selectedTask = task
                            selectedStep = viewModel.requiredActivityStep
                            isTaskSheetPresented = true
                        }
                    )
                }

                // مكان قسم التقدم الأسبوعي لاحقًا
            }
            .padding(Spacing.pageMargin)
        }
        .background(Color.pageBackground.ignoresSafeArea())
        .environment(\.layoutDirection, .rightToLeft)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $isTaskSheetPresented) {
            if let task = selectedTask {
                TaskSheet(
                    task: task,
                    step: selectedStep
                )
            }
        }
    }
}
