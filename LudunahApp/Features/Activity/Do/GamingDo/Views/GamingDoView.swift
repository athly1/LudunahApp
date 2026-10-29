
// gamingDoView.swift - واجهة تطبيق الألعاب الإلكترونية.
//
// Contains:
// - Shared ActivityHeader with stable top position.
// - Gaming activity title and instructions.
// - Scrollable content for smaller screens.
// - Countdown timer with Art Do direction.
// - Fixed space for pause and resume controls.
// - Start and finish actions.
// - Stop timer when leaving the activity.
//
// Used by: InstructionsSheet (gaming, do).
//
// Learn: @StateObject, @State, @Environment,
//        ScrollView, safeAreaInset,
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
            .padding(.top, Spacing.space16)

            // MARK: - Scrollable Content

            ScrollView {

                VStack(spacing: 0) {

                    // MARK: - Activity Title

                    Text(viewModel.title)
                        .font(.title1Heading)
                        .foregroundStyle(Color.textPrimary)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding(
                            .horizontal,
                            Spacing.pageMargin
                        )
                        .padding(.top, Spacing.space24)
                        .padding(.bottom, Spacing.space8)

                    // MARK: - Duration

                    HStack(spacing: 8) {

                        Image(systemName: "gauge.with.needle")
                            .foregroundStyle(Color.textPrimary)
                            .opacity(0.75)

                        Text(
                            "أمامك \(viewModel.durationMin) دقائق"
                        )
                        .font(.supTitle2)
                        .foregroundStyle(Color.textPrimary)
                        .opacity(0.75)

                        Spacer()
                    }
                    .padding(
                        .horizontal,
                        Spacing.pageMargin
                    )
                    .padding(.bottom, Spacing.space32)

                    // MARK: - Instructions

                    DoStepsCard(
                        howTo: viewModel.steps,
                        stepRingColor: .mapSequers
                    )
                    .padding(
                        .horizontal,
                        Spacing.pageMargin
                    )
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
                    .padding(.top, Spacing.space16)
                    .padding(.bottom, Spacing.space24)
                }
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(
            Color.pageBackground.ignoresSafeArea()
        )

        // الأزرار في الأسفل خارج المحتوى المتحرك
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomControls
        }

        .environment(
            \.layoutDirection,
            .rightToLeft
        )
        .toolbar(.hidden, for: .navigationBar)

        .onDisappear {
            timerEngine.pause()
        }
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {

        VStack(spacing: Spacing.space12) {

            // نحجز مكان زر الإيقاف دائمًا
            // حتى لا يتغير ارتفاع منطقة الأزرار
            ZStack {

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
            }
            .frame(height: 44)

            // MARK: - Main Button

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
        .padding(
            .horizontal,
            Spacing.pageMargin
        )
        .padding(.top, Spacing.space12)
        .padding(.bottom, Spacing.space16)
        .frame(maxWidth: .infinity)
        .background(Color.pageBackground)
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
