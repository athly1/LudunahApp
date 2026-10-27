
// ArtDoView.swift - واجهة التكوين البصري الصامت.
//
// Contains:
// - Shared ActivityHeader.
// - Five-minute collecting activity.
// - Sunset color palette.
// - Ten-second reflection screen.
// - Automatic return to Home.
//
// Used by: ActivityFlowView (art, do).
// Learn: @State, @Environment, @ViewBuilder,
//       conditional views, onChange, sheet.

import SwiftUI

struct ArtDoView: View {

    // MARK: - Properties

    // منطق النشاط والمؤقت
    @State private var viewModel = ArtDoViewModel()

    // مدير التنقل
    @Environment(AppRouter.self) private var appRouter

    // زر الرجوع إلى الصفحة السابقة
    @Environment(\.dismiss) private var dismiss

    // حالة التطبيق
    @Environment(\.scenePhase) private var scenePhase

    // إظهار التعليمات
    @State private var showInstructions = false

    // منع تسجيل الإنجاز مرتين
    @State private var didFinish = false

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(spacing: Spacing.space24) {

                // الهيدر المشترك
                ActivityHeader(
                    interestTitle: "الفن السعودي",
                    interestColor: .artChipBackground,
                    stepTitle: "طبّق",
                    stepIcon: "hand.draw",
                    onBack: {
                        viewModel.pause()
                        dismiss()
                    }
                )

                // شريط تقدم المؤقت
                ProgressView(value: viewModel.progress)
                    .tint(Color.actionPrimary)

                // محتوى الشاشة حسب المرحلة
                if viewModel.isReflecting {

                    // شاشة التأمل
                    reflectionContent

                } else {

                    // شاشة جمع العناصر
                    collectingContent
                }
            }
            .padding(.horizontal, Spacing.pageMargin)
            .padding(.top, Spacing.space16)
            .padding(.bottom, Spacing.space24)
        }

        // زر أسفل شاشة جمع العناصر فقط
        
        .safeAreaInset(edge: .bottom) {

            // عرض الزر في شاشة الجمع وشاشة التأمل
            if !viewModel.isCompleted {

                bottomButton
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.vertical, Spacing.space8)
                    .background(Color.pageBackground)
            }
        }


        // Design System
        .background(
            Color.pageBackground.ignoresSafeArea()
        )

        .toolbar(.hidden, for: .navigationBar)

        .environment(
            \.layoutDirection,
            .rightToLeft
        )

        // تعليمات النشاط
        .sheet(isPresented: $showInstructions) {

            instructionsContent
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }

        // عند اكتمال التأمل تلقائيًا
        .onChange(of: viewModel.isCompleted) { _, completed in

            if completed {
                finishActivity()
            }
        }

        // إيقاف المؤقت عند مغادرة الشاشة
        .onDisappear {
            viewModel.pause()
        }

        // إيقاف المؤقت إذا خرج التطبيق للخلفية
        .onChange(of: scenePhase) { _, newPhase in

            if newPhase != .active {
                viewModel.pause()
            }
        }
    }

    // MARK: - Collecting Content

    // شاشة جمع العناصر وترتيبها
    private var collectingContent: some View {

        VStack(spacing: Spacing.space24) {

            // عنوان النشاط
            HStack(spacing: Spacing.space8) {

                Text(viewModel.activity.title)
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)

                Button {
                    showInstructions = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.textPrimary)
                }

                Spacer()
            }

            // وصف الوقت
            Text("المدة: ٥ دقائق")
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)

            // بطاقة الألوان
            colorsCard

            // المؤقت الدائري
            timerView
        }
    }

    // MARK: - Colors Card

    private var colorsCard: some View {

        VStack(spacing: Spacing.space16) {

            Text("لوحة اليوم: \(viewModel.activity.theme)")
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)

            // ثلاثة ألوان لغروب الشمس
            HStack(spacing: Spacing.space16) {

                ForEach(
                    viewModel.activity.colors,
                    id: \.self
                ) { color in

                    Circle()
                        .fill(Color(hex: color))
                        .frame(width: 64, height: 64)
                }
            }

            // شرح المطلوب
            Text(
                "اجمع ٣ عناصر من حولك تحمل هذه الألوان أو درجات قريبة منها، ثم رتّبها أمامك كلوحة صامتة."
            )
            .font(.titleCards)
            .foregroundStyle(Color.textPrimary)
            .multilineTextAlignment(.center)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }

        .frame(maxWidth: .infinity)

        .padding(Spacing.space16)

        .background(
            Color.glassBackground,
            in: RoundedRectangle(cornerRadius: 18)
        )

        .shadow(
            color: .black.opacity(0.07),
            radius: 8,
            y: 4
        )
    }

    // MARK: - Reflection Content

    // شاشة التأمل بعد الضغط على أنهيت
    private var reflectionContent: some View {

        VStack(spacing: Spacing.space24) {

            // عنوان النشاط
            Text(viewModel.activity.title)
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            // تعليمات التأمل
            Text(viewModel.activity.reflectionText)
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            // عداد 10 ثوانٍ
            timerView
        }
        .padding(.top, Spacing.space24)
    }

    // MARK: - Timer View

    // مؤقت واحد تتغير مدته حسب المرحلة
    private var timerView: some View {

        ZStack {

            Circle()
                .stroke(
                    Color(hex: "#8B3A2F"),
                    lineWidth: 3
                )

            Text(viewModel.formattedTime)
                .font(.title1Heading)
                .monospacedDigit()
                .foregroundStyle(Color.textPrimary)
        }
        .frame(width: 130, height: 130)
        .padding(.vertical, Spacing.space16)
    }

    
    // MARK: - Bottom Button

    @ViewBuilder
    private var bottomButton: some View {

        // قبل بدء النشاط
        if viewModel.stage == .ready {

            PrimaryButton(title: "ابدأ") {

                // بدء مؤقت الخمس دقائق
                viewModel.startActivity()
            }

        // أثناء جمع العناصر وترتيبها
        } else if viewModel.stage == .collecting {

            PrimaryButton(title: "أنهيت") {

                // الانتقال إلى شاشة التأمل
                viewModel.startReflection()
            }

        // أثناء التأمل لمدة 10 ثوانٍ
        } else if viewModel.stage == .reflecting {

            PrimaryButton(
                title: "أنهيت",
                isDisabled: didFinish
            ) {

                // إيقاف مؤقت التأمل
                viewModel.pause()

                // تسجيل الإنجاز والرجوع إلى Home
                finishActivity()
            }
        }
    }

    
    // MARK: - Finish Activity

    private func finishActivity() {

        // منع تنفيذ الإنهاء مرتين
        guard !didFinish else {
            return
        }

        didFinish = true

        // تسجيل النشاط المكتمل
        StorageService().recordCompletedActivity(
            interest: .art
        )

        // الرجوع إلى الرئيسية
        appRouter.popToRoot()
    }

    // MARK: - Instructions Sheet

    private var instructionsContent: some View {

        VStack(spacing: Spacing.space24) {

            Text("طريقة أداء النشاط")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            VStack(
                alignment: .leading,
                spacing: Spacing.space16
            ) {

                ForEach(
                    Array(viewModel.activity.howTo.enumerated()),
                    id: \.offset
                ) { index, instruction in

                    HStack(
                        alignment: .top,
                        spacing: Spacing.space12
                    ) {

                        // رقم الخطوة
                        Text("\(index + 1)")
                            .font(.titleCards)
                            .foregroundStyle(Color.textPrimary)
                            .frame(width: 30, height: 30)
                            .background(
                                Color.actionPrimary,
                                in: Circle()
                            )

                        // نص التعليمات
                        Text(instruction)
                            .font(.titleCards)
                            .foregroundStyle(Color.textPrimary)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                    }
                }
            }

            Spacer(minLength: 0)

            PrimaryButton(title: "فهمت") {
                showInstructions = false
            }
        }
        .padding(Spacing.pageMargin)
        .background(
            Color.pageBackground.ignoresSafeArea()
        )
        .environment(
            \.layoutDirection,
            .rightToLeft
        )
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

            Button("افتح نشاط الفن Do") {
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
