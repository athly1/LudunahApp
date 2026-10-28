
// ArtDoView.swift - واجهة نشاط التكوين البصري الصامت.
//
// Contains:
// - Shared ActivityHeader.
// - DoStepsCard for instructions.
// - Shared CountdownTimerView and TimerEngine.
// - Five-minute collecting activity.
// - Ten-second reflection.
// - RTL circular timer movement.
// - Manual finish and return to Home.
//
// Used by: ActivityFlowView (art, do).
//
// Learn: @StateObject, @State, @Environment,
//        conditional views, functions.

import SwiftUI

// MARK: - Art Do View

struct ArtDoView: View {

    // MARK: - Properties

    // منطق مراحل النشاط
    @State private var viewModel = ArtDoViewModel()

    // مؤقت جمع العناصر: 5 دقائق
    @StateObject private var collectingTimer =
        TimerEngine(duration: 300)

    // مؤقت التأمل: 10 ثوانٍ
    @StateObject private var reflectionTimer =
        TimerEngine(duration: 10)

    // مدير التنقل
    @Environment(AppRouter.self) private var appRouter

    // الرجوع للشاشة السابقة
    @Environment(\.dismiss) private var dismiss

    // منع تسجيل الإنجاز مرتين
    @State private var didFinish = false

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            // الهيدر المشترك للفريق
            ActivityHeader(
                interestTitle: "الفن السعودي",
                interestColor: .artChipBackground,
                stepTitle: "طبّق",
                stepIcon: "hand.draw",
                onBack: {
                    collectingTimer.pause()
                    reflectionTimer.pause()
                    dismiss()
                }
            )
            .padding(.horizontal, Spacing.pageMargin)
            .padding(.top, Spacing.space16)

            // محتوى النشاط
            ScrollView {

                VStack(spacing: Spacing.space24) {

                    // عنوان النشاط
                    Text(viewModel.activity.title)
                        .font(.title1Heading)
                        .foregroundStyle(Color.textPrimary)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )

                    // المحتوى حسب مرحلة النشاط
                    if viewModel.stage == .reflecting {

                        reflectionContent

                    } else {

                        collectingContent
                    }
                }
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.top, Spacing.space24)
                .padding(.bottom, Spacing.space24)
            }

            // زر النشاط أسفل الشاشة
            if viewModel.stage != .completed {

                bottomButton
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.vertical, Spacing.space16)
            }
        }

        // خلفية التطبيق
        .background(
            Color.pageBackground.ignoresSafeArea()
        )

        // إخفاء Navigation Bar الافتراضي
        .toolbar(.hidden, for: .navigationBar)

        // اتجاه الواجهة العربية
        .environment(
            \.layoutDirection,
            .rightToLeft
        )

        // إيقاف المؤقتات عند مغادرة الشاشة
        .onDisappear {
            collectingTimer.pause()
            reflectionTimer.pause()
        }
    }

    // MARK: - Collecting Content

    // مرحلة جمع العناصر وترتيبها
    private var collectingContent: some View {

        VStack(spacing: Spacing.space24) {

            // وصف مدة النشاط
            HStack(spacing: Spacing.space8) {

                Image(systemName: "gauge.with.needle")
                    .foregroundStyle(Color.textPrimary)

                Text("أمامك ٥ دقائق")
                    .font(.titleCards)
                    .foregroundStyle(Color.textPrimary)

                Spacer()
            }

            // لوحة ألوان غروب الشمس
            sunsetColorsCard

            // خطوات النشاط باستخدام مكون الفريق
            DoStepsCard(
                howTo: Array(
                    viewModel.activity.howTo.prefix(2)
                ),
                stepRingColor: .artChipBackground
            )

            // مؤقت جمع العناصر
            currentTimerView
        }
    }

    // MARK: - Sunset Colors

    // بطاقة الألوان المستخدمة في النشاط
    private var sunsetColorsCard: some View {

        VStack(spacing: Spacing.space16) {

            Text("لوحة اليوم: \(viewModel.activity.theme)")
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)

            HStack(spacing: Spacing.space16) {

                ForEach(
                    viewModel.activity.colors,
                    id: \.self
                ) { color in

                    Circle()
                        .fill(Color(hex: color))
                        .frame(width: 60, height: 60)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.space16)
        .background(
            Color.glassBackground,
            in: RoundedRectangle(cornerRadius: 18)
        )
    }

    // MARK: - Reflection Content

    // مرحلة التأمل لمدة 10 ثوانٍ
    private var reflectionContent: some View {

        VStack(spacing: Spacing.space24) {

            Text("تأمل لوحتك")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            Text(viewModel.activity.reflectionText)
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            // مؤقت التأمل
            currentTimerView
        }
        .padding(.top, Spacing.space24)
    }

    // MARK: - Current Timer

    // تحديد المؤقت حسب مرحلة النشاط
    @ViewBuilder
    private var currentTimerView: some View {

        if viewModel.stage == .reflecting {

            // مؤقت التأمل: 10 ثوانٍ
            CountdownTimerView(
                engine: reflectionTimer,
                color: Color(hex: "#8B3A2F"),
                size: 145,

                // عكس اتجاه حركة الدائرة
                isRTL: true,

                // إظهار انتهاء الوقت داخل الدائرة فقط
                showsFinishedCaption: false
            )
            .frame(maxWidth: .infinity)

        } else {

            // مؤقت جمع العناصر: 5 دقائق
            CountdownTimerView(
                engine: collectingTimer,
                color: Color(hex: "#8B3A2F"),
                size: 145,

                // عكس اتجاه حركة الدائرة
                isRTL: true,

                // إظهار انتهاء الوقت داخل الدائرة فقط
                showsFinishedCaption: false
            )
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Bottom Button

    // الزر يتغير حسب مرحلة النشاط
    @ViewBuilder
    private var bottomButton: some View {

        // قبل بدء النشاط
        if viewModel.stage == .ready {

            PrimaryButton(title: "ابدأ") {

                // الانتقال إلى مرحلة جمع العناصر
                viewModel.startActivity()

                // تشغيل مؤقت الخمس دقائق
                collectingTimer.start()
            }

        // أثناء جمع العناصر أو بعد انتهاء الوقت
        } else if viewModel.stage == .collecting {

            PrimaryButton(title: "أنهيت") {

                // إيقاف مؤقت جمع العناصر
                collectingTimer.pause()

                // الانتقال إلى التأمل
                viewModel.startReflection()

                // تشغيل مؤقت 10 ثوانٍ
                reflectionTimer.start()
            }

        // أثناء التأمل أو بعد انتهاء 10 ثوانٍ
        } else if viewModel.stage == .reflecting {

            PrimaryButton(
                title: "أنهيت",
                isDisabled: didFinish
            ) {

                // إنهاء النشاط يدويًا
                finishActivity()
            }
        }
    }

    // MARK: - Finish Activity

    private func finishActivity() {

        // منع تسجيل الإنجاز مرتين
        guard !didFinish else {
            return
        }

        // الإنهاء مسموح بعد الوصول إلى التأمل
        guard viewModel.stage == .reflecting else {
            return
        }

        didFinish = true

        // إيقاف المؤقتين
        collectingTimer.pause()
        reflectionTimer.pause()

        // تحديث مرحلة النشاط
        viewModel.finishActivity()

        // تسجيل النشاط المكتمل
        StorageService().recordCompletedActivity(
            interest: .art
        )

        // العودة للرئيسية بعد ضغط المستخدم
        appRouter.popToRoot()
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
