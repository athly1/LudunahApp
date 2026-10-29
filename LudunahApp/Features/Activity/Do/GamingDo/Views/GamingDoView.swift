
// gamingDoView.swift - واجهة تطبيق الألعاب الإلكترونية.
//
// Contains:
// - Shared ActivityHeader.
// - Gaming activity title and instructions.
// - Countdown timer with Art Do direction.
// - Separate pause and resume controls.
// - Start and finish actions.
// - Stop timer when leaving the activity.
//
// Used by: InstructionsSheet (gaming, do).
//
// Learn: @StateObject, @State, @Environment,
//        TimerEngine, CountdownTimerView, Button.

import SwiftUI

// MARK: - Gaming Do View

struct gamingDoView: View {

    // MARK: - Properties

    @StateObject private var viewModel: GamingDoViewModel
    @StateObject private var timerEngine: TimerEngine

    // هل بدأ النشاط؟
    @State private var hasStarted = false

    // هل انتهى النشاط؟
    @State private var isDone = false

    // الرجوع للشاشة السابقة
    @Environment(\.dismiss) private var dismiss

    // MARK: - Initialization

    init() {

        let model = GamingDoViewModel()

        _viewModel = StateObject(
            wrappedValue: model
        )

        // تحويل الدقائق إلى ثوانٍ
        _timerEngine = StateObject(
            wrappedValue: TimerEngine(
                duration: model.durationMin * 60
            )
        )
    }

    // MARK: - Body

    var body: some View {

        ZStack {

            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: - Header

                ActivityHeader(
                    interestTitle: "الألعاب الإلكترونية",
                    interestColor: .gamingChip,
                    stepTitle: "طبّق",
                    stepIcon: "gamecontroller",
                    onBack: {
                        timerEngine.pause()
                        dismiss()
                    }
                )
                .padding(.horizontal, Spacing.pageMargin)

                // MARK: - Activity Title

                Text(viewModel.title)
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.chipHeight)
                    .padding(.bottom, Spacing.space8)

                // MARK: - Duration

                HStack(spacing: 8) {

                    Image(systemName: "gauge.with.needle")
                        .foregroundStyle(Color.textPrimary)
                        .opacity(0.75)

                    Text("أمامك \(viewModel.durationMin) دقائق")
                        .font(.supTitle2)
                        .foregroundStyle(Color.textPrimary)
                        .opacity(0.75)

                    Spacer()
                }
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.bottom, Spacing.space32)

                // MARK: - Instructions

                DoStepsCard(
                    howTo: viewModel.steps,
                    stepRingColor: .mapSequers
                )
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.bottom, Spacing.space32)

                // MARK: - Countdown Timer

                CountdownTimerView(
                    engine: timerEngine,
                    color: .mapTimerRing,
                    size: 145,
                    isRTL: true,
                    showsFinishedCaption: false
                )
                .frame(
                    maxWidth: .infinity,
                    alignment: .center
                )
                .padding(.top, Spacing.headerTitleOffset)
                .padding(.bottom, Spacing.headerTitleOffset)

                Spacer(minLength: 0)

                // MARK: - Bottom Controls

                VStack(spacing: Spacing.space12) {

                    // زر إيقاف مؤقت / أكمل
                    if hasStarted && !timerEngine.isFinished {

                        Button {

                            if timerEngine.isRunning {
                                timerEngine.pause()
                            } else {
                                timerEngine.resume()
                            }

                        } label: {

                            Label(
                                timerEngine.isRunning
                                    ? "إيقاف مؤقت"
                                    : "أكمل",
                                systemImage: timerEngine.isRunning
                                    ? "pause.fill"
                                    : "play.fill"
                            )
                            .font(.titleCards)
                            .foregroundStyle(Color.textPrimary)
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 44
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    // الزر الرئيسي
                    PrimaryButton(
                        title: hasStarted ? "انتهيت" : "ابدأ",
                        isDisabled: isDone
                    ) {

                        if !hasStarted {

                            startActivity()

                        } else {

                            finishActivity()
                        }
                    }
                }
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.bottom, Spacing.space16)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .environment(
            \.layoutDirection,
            .rightToLeft
        )
        .onDisappear {
            timerEngine.pause()
        }
    }

    // MARK: - Start Activity

    private func startActivity() {

        guard !hasStarted else {
            return
        }

        hasStarted = true
        timerEngine.start()
    }

    // MARK: - Finish Activity

    private func finishActivity() {

        guard hasStarted && !isDone else {
            return
        }

        isDone = true
        timerEngine.pause()
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    gamingDoView()
}
