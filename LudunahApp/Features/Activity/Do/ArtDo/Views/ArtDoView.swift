
// ArtDoView.swift - واجهة أنشطة تطبيق الفن.
//
// Contains:
// - Shared ActivityHeader.
// - Random activity from Art.json.
// - Activity description.
// - Colors or SF Symbols.
// - Instructions bottom sheet.
// - Dynamic activity phases.
// - Shared CountdownTimerView.
// - Optional pause and resume.
// - Manual completion and Home navigation.
//
// Used by: ActivityFlowView (art, do).
//
// Learn: @StateObject, @State, @Environment,
//        sheet, functions, conditional views.

import SwiftUI
import Combine

// MARK: - Art Do View

struct ArtDoView: View {

    // MARK: - Properties

    // إدارة النشاط المختار عشوائيًا ومراحله
    @State private var viewModel = ArtDoViewModel()

    // إدارة مؤقتات المراحل باستخدام StateObject
    @StateObject private var timers = ArtDoTimers()

    // التحكم في نافذة التعليمات
    @State private var showInstructions = false

    // منع تسجيل الإنجاز مرتين
    @State private var didFinish = false

    // مدير التنقل
    @Environment(AppRouter.self) private var appRouter

    // الرجوع للشاشة السابقة
    @Environment(\.dismiss) private var dismiss

    // MARK: - Current Timer

    // المؤقت الخاص بالمرحلة الحالية
    private var currentTimer: TimerEngine? {
        timers.timer(at: viewModel.phaseIndex)
    }

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Shared Header

            ActivityHeader(
                interestTitle: "الفن السعودي",
                interestColor: .artChipBackground,
                stepTitle: "طبّق",
                stepIcon: "hand.draw",
                onBack: {

                    // إيقاف المؤقتات عند الرجوع
                    timers.stopAll()

                    // العودة للشاشة السابقة
                    dismiss()
                }
            )
            .padding(.horizontal, Spacing.pageMargin)
            .padding(.top, Spacing.space16)

            // MARK: - Progress

            if viewModel.activity != nil {

                ProgressView(
                    value: Double(
                        viewModel.stage == .ready
                            ? 0
                            : viewModel.currentPhaseNumber - 1
                    ),
                    total: Double(
                        max(viewModel.totalPhases, 1)
                    )
                )
                .tint(Color.actionPrimary)
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.top, Spacing.space16)
            }

            // MARK: - Main Content

            ScrollView {

                if let activity = viewModel.activity {

                    VStack(spacing: Spacing.space24) {

                        // عنوان النشاط
                        activityTitle(activity.title)

                        if viewModel.stage == .ready {

                            // قبل بدء النشاط
                            readyContent

                        } else if viewModel.stage == .running {

                            // أثناء تنفيذ النشاط
                            phaseContent
                        }

                        // المؤقت الدائري
                        currentTimerView
                    }
                    .padding(
                        .horizontal,
                        Spacing.pageMargin
                    )
                    .padding(.top, Spacing.space24)
                    .padding(.bottom, Spacing.space24)

                } else {

                    // رسالة عند فشل تحميل النشاط
                    Text(
                        viewModel.errorMessage
                            ?? "لا يوجد نشاط متاح."
                    )
                    .font(.titleCards)
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(Spacing.pageMargin)
                }
            }

            // MARK: - Bottom Controls

            if viewModel.activity != nil &&
               viewModel.stage != .completed {

                bottomControls
                    .padding(
                        .horizontal,
                        Spacing.pageMargin
                    )
                    .padding(
                        .vertical,
                        Spacing.space16
                    )
            }
        }

        // MARK: - Design System

        .background(
            Color.pageBackground.ignoresSafeArea()
        )

        .toolbar(.hidden, for: .navigationBar)

        // الاتجاه العربي للواجهة
        .environment(
            \.layoutDirection,
            .rightToLeft
        )

        // MARK: - Instructions Sheet

        .sheet(isPresented: $showInstructions) {

            instructionsSheet
                .presentationDetents([
                    .medium,
                    .large
                ])
                .presentationDragIndicator(.visible)
        }

        // MARK: - Lifecycle

        .onAppear {

            // تجهيز مؤقتات النشاط المختار
            if let activity = viewModel.activity {
                timers.configure(phases: activity.phases)
            }
        }

        .onDisappear {

            // إيقاف جميع المؤقتات عند مغادرة الشاشة
            timers.stopAll()
        }
    }

    // MARK: - Activity Title

    // عرض عنوان النشاط وأيقونة المعلومات
    private func activityTitle(
        _ title: String
    ) -> some View {

        HStack(
            alignment: .firstTextBaseline,
            spacing: Spacing.space8
        ) {

            Text(title)
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            Button {

                // فتح نافذة التعليمات
                showInstructions = true

            } label: {

                Image(systemName: "info.circle")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.textPrimary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("طريقة أداء النشاط")

            Spacer(minLength: 0)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }

    // MARK: - Ready Content

    // المحتوى قبل الضغط على ابدأ
    private var readyContent: some View {

        VStack(spacing: Spacing.space24) {

            // مدة النشاط
            HStack(spacing: Spacing.space8) {

                Image(systemName: "gauge.with.needle")
                    .foregroundStyle(Color.textPrimary)
                    .opacity(0.75)

                Text(
                    "أمامك \(viewModel.activity?.durationMin ?? 0) دقائق"
                )
                .font(.supTitle2)
                .foregroundStyle(Color.textPrimary)
                .opacity(0.75)

                Spacer()
            }

            // بطاقة النشاط
            activityCard
        }
    }

    // MARK: - Activity Card

    // تعرض الألوان أو الرموز حسب JSON
    private var activityCard: some View {

        VStack(spacing: Spacing.space16) {

            if let activity = viewModel.activity {

                // عنوان البطاقة
                Text(
                    activity.displayType == "symbols"
                        ? activity.theme
                        : "لوحة اليوم: \(activity.theme)"
                )
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)

                // MARK: - Symbols

                if activity.displayType == "symbols" {

                    HStack(spacing: Spacing.space12) {

                        ForEach(
                            activity.symbols,
                            id: \.self
                        ) { symbol in

                            Image(systemName: symbol)
                                .font(.system(size: 23))
                                .foregroundStyle(
                                    Color.textPrimary
                                )
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: 54
                                )
                                .background(
                                    Color.pageBackground,
                                    in: RoundedRectangle(
                                        cornerRadius: 12
                                    )
                                )
                        }
                    }

                } else {

                    // MARK: - Colors

                    HStack(spacing: Spacing.space16) {

                        ForEach(
                            activity.colors,
                            id: \.self
                        ) { color in

                            Circle()
                                .fill(Color(hex: color))
                                .frame(
                                    width: 60,
                                    height: 60
                                )
                        }
                    }
                }

                // MARK: - Description

                Text(activity.description)
                    .font(.titleCards)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.space24)
        .background(
            Color.glassBackground,
            in: RoundedRectangle(cornerRadius: 20)
        )
        .shadow(
            color: .black.opacity(0.10),
            radius: 12,
            x: 0,
            y: 6
        )
    }

    // MARK: - Phase Content

    // عرض معلومات المرحلة الحالية
    private var phaseContent: some View {

        VStack(spacing: Spacing.space24) {

            // رقم المرحلة
            Text(
                "المرحلة \(viewModel.currentPhaseNumber) من \(viewModel.totalPhases)"
            )
            .font(.supTitle2)
            .foregroundStyle(
                Color.textPrimary.opacity(0.75)
            )

            // نص المرحلة من Art.json
            if let phase = viewModel.currentPhase {

                Text(phase.text)
                    .font(.titleCards)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Spacing.space16)
    }

    // MARK: - Timer View

    // نفس المؤقت المستخدم في Gaming Do
    @ViewBuilder
    private var currentTimerView: some View {

        if let timer = currentTimer {

            CountdownTimerView(
                engine: timer,
                color: .artTimerRing,
                size: 145,

                // حركة دائرة المؤقت بالعربي
                isRTL: true,

                // انتهاء الوقت داخل الدائرة فقط
                showsFinishedCaption: false
            )
            .frame(maxWidth: .infinity)
            .padding(.top, Spacing.space16)
        }
    }

    // MARK: - Instructions Sheet

    private var instructionsSheet: some View {

        VStack(spacing: Spacing.space24) {

            HStack(spacing: Spacing.space8) {

                Image(systemName: "info.circle")
                    .foregroundStyle(Color.textPrimary)

                Text("طريقة أداء النشاط")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)

                Spacer()
            }

            ScrollView {

                if let activity = viewModel.activity {

                    // مكون الفريق لعرض الخطوات
                    DoStepsCard(
                        howTo: activity.howTo,
                        stepRingColor: .artChipBackground
                    )
                }
            }

            PrimaryButton(title: "فهمت") {

                showInstructions = false
            }
        }
        .padding(Spacing.pageMargin)
        .padding(.top, Spacing.space16)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(
            Color.pageBackground.ignoresSafeArea()
        )
        .environment(
            \.layoutDirection,
            .rightToLeft
        )
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {

        VStack(spacing: Spacing.space12) {

            // زر الإيقاف يظهر فقط عند السماح بذلك
            if viewModel.stage == .running,
               viewModel.canPauseCurrentPhase,
               let timer = currentTimer,
               !timer.isFinished {

                Button {

                    if timer.isRunning {

                        // إيقاف مؤقت
                        timer.pause()

                    } else {

                        // استكمال
                        timer.resume()
                    }

                } label: {

                    Label(
                        timer.isRunning
                            ? "إيقاف مؤقت"
                            : "أكمل",
                        systemImage: timer.isRunning
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
                .accessibilityLabel(
                    timer.isRunning
                        ? "إيقاف مؤقت"
                        : "استكمال المؤقت"
                )
            }

            // الزر الرئيسي
            mainButton
        }
    }

    // MARK: - Main Button

    @ViewBuilder
    private var mainButton: some View {

        // قبل بدء النشاط
        if viewModel.stage == .ready {

            PrimaryButton(
                title: "ابدأ",
                isDisabled: currentTimer == nil
            ) {

                startActivity()
            }

        // المرحلة الأخيرة
        } else if viewModel.isLastPhase {

            PrimaryButton(
                title: "انتهيت",
                isDisabled: didFinish
            ) {

                finishActivity()
            }

        // الانتقال للمراحل التالية
        } else {

            PrimaryButton(
                title: viewModel.activity?.id == "art-do-1"
                    ? "أنهيت"
                    : "التالي"
            ) {

                nextPhase()
            }
        }
    }

    // MARK: - Start Activity

    private func startActivity() {

        guard viewModel.stage == .ready,
              let timer = currentTimer else {
            return
        }

        // بدء النشاط
        viewModel.startActivity()

        // تشغيل المؤقت
        timer.start()
    }

    // MARK: - Next Phase

    private func nextPhase() {

        guard viewModel.stage == .running,
              !viewModel.isLastPhase else {
            return
        }

        // إيقاف المؤقت الحالي
        currentTimer?.pause()

        // الانتقال للمرحلة التالية
        viewModel.nextPhase()

        // تشغيل المؤقت الجديد
        currentTimer?.start()
    }

    // MARK: - Stop Timers

    private func stopAllTimers() {
        timers.stopAll()
    }

    // MARK: - Finish Activity

    private func finishActivity() {

        guard !didFinish,
              viewModel.stage == .running,
              viewModel.isLastPhase else {
            return
        }

        // منع الضغط المتكرر
        didFinish = true

        // إيقاف المؤقتات
        stopAllTimers()

        // تحديث حالة النشاط
        viewModel.finishActivity()

        // تسجيل النشاط المكتمل
        StorageService().recordCompletedActivity(
            interest: .art
        )

        // العودة إلى Home
        appRouter.popToRoot()
    }
}

// MARK: - Art Do Timers

// كلاس لإدارة مؤقتات جميع مراحل النشاط.
// يستخدم ObservableObject مثل Gaming Do.

@MainActor
final class ArtDoTimers: ObservableObject {

    // تخزين المؤقتات وإبلاغ SwiftUI عند تجهيزها
    @Published private(set) var engines: [TimerEngine] = []

    // MARK: - Configure

    // تجهيز مؤقت لكل مرحلة حسب مدتها من JSON
    func configure(phases: [ArtDoPhase]) {

        // لا نكرر إنشاء المؤقتات
        guard engines.isEmpty else {
            return
        }

        engines = phases.map { phase in

            TimerEngine(
                duration: phase.durationSec
            )
        }
    }

    // MARK: - Timer

    // إرجاع المؤقت الخاص بالمرحلة المطلوبة
    func timer(at index: Int) -> TimerEngine? {

        guard engines.indices.contains(index) else {
            return nil
        }

        return engines[index]
    }

    // MARK: - Stop All

    // إيقاف جميع المؤقتات عند مغادرة الشاشة
    func stopAll() {

        for engine in engines {
            engine.pause()
        }
    }
}

// MARK: - Preview

#Preview {

    let router = AppRouter()

    NavigationStack(
        path: Binding(
            get: { router.path },
            set: { router.path = $0 }
        )
    ) {

        VStack(spacing: 20) {

            Text("الرئيسية")
                .font(.title)

            Button("افتح Art Do") {

                router.push(.activity(.art))
            }
        }
        .navigationDestination(for: AppRoute.self) { route in

            switch route {

            case .activity:
                ArtDoView()

            case .settings:
                Text("الإعدادات")
            }
        }
    }
    .environment(router)
    .environment(\.layoutDirection, .rightToLeft)
}
