
//
// ArtCreateView.swift - واجهة نشاط ابتكر في الفن السعودي.
//
// Contains:
// - Shared ActivityHeader with back button.
// - Interactive 5x5 pixel grid.
// - Six-color palette and undo button.
// - Reflection question and answer field.
// - Instructions bottom sheet.
// - Save activity and return to Home.
//
// Used by: ActivityFlowView (art, create).
//
// Learn: @State, @Environment, @FocusState,
//        LazyVGrid, ForEach, Button, sheet, dismiss.
//

import SwiftUI

// MARK: - Art Create View

struct ArtCreateView: View {

    // MARK: - Properties

    // مسؤول عن الرسم والألوان ومنطق النشاط
    @State private var viewModel = ArtCreateViewModel()

    // الرجوع للشاشة السابقة
    @Environment(\.dismiss) private var dismiss

    // مدير التنقل المشترك في التطبيق
    @Environment(AppRouter.self) private var appRouter

    // إظهار وإخفاء نافذة التعليمات
    @State private var showInstructions = false

    // التحكم في لوحة المفاتيح
    @FocusState private var isAnswerFocused: Bool

    // منع الضغط المتكرر على زر الإنهاء
    @State private var isFinishing = false

    // إعداد أعمدة شبكة الرسم الخمسة
    private let gridColumns = Array(
        repeating: GridItem(.flexible(), spacing: 3),
        count: 5
    )

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(spacing: Spacing.space24) {

                // الهيدر المشترك الخاص بالفريق
                ActivityHeader(
                    interestTitle: "الفن السعودي",
                    interestColor: .artChipBackground,
                    stepTitle: "ابتكر",
                    stepIcon: "sparkles",
                    onBack: {
                        dismiss()
                    }
                )

                // عنوان النشاط وزر المعلومات
                activityTitle

                // شبكة التلوين
                pixelGrid

                // لوحة الألوان والتراجع
                colorPalette

                // سؤال معنى الرمز
                reflectionSection
            }
            .padding(.horizontal, Spacing.pageMargin)
            .padding(.top, Spacing.space16)
            .padding(.bottom, Spacing.space24)
        }

        // تثبيت زر أنهيت في أسفل الشاشة
        .safeAreaInset(edge: .bottom) {

            finishButton
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.vertical, Spacing.space8)
                .background(Color.pageBackground)
        }

        // خلفية Design System
        .background(
            Color.pageBackground.ignoresSafeArea()
        )

        // إخفاء شريط التنقل الافتراضي
        .toolbar(.hidden, for: .navigationBar)

        // اتجاه التطبيق العربي
        .environment(\.layoutDirection, .rightToLeft)

        // نافذة تعليمات النشاط
        .sheet(isPresented: $showInstructions) {

            instructionsContent
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Activity Title

    private var activityTitle: some View {

        HStack(spacing: Spacing.space8) {

            // عنوان التحدي
            Text("صمّم رمز يحكي يومك")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            // زر فتح التعليمات
            Button {

                showInstructions = true

            } label: {

                Image(systemName: "info.circle")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.textPrimary)
            }
            .accessibilityLabel("طريقة أداء النشاط")

            Spacer()
        }
    }

    // MARK: - Pixel Grid

    private var pixelGrid: some View {

        LazyVGrid(
            columns: gridColumns,
            spacing: 3
        ) {

            // عرض مربعات التصميم الـ 25
            ForEach(
                viewModel.pattern.cellColors.indices,
                id: \.self
            ) { index in

                Button {

                    // إغلاق لوحة المفاتيح
                    isAnswerFocused = false

                    // تلوين المربع المحدد
                    viewModel.paintCell(at: index)

                } label: {

                    Rectangle()

                        // قراءة لون المربع من Model
                        .fill(
                            Color(
                                hex: viewModel.pattern.cellColors[index]
                            )
                        )

                        // جعل الخلية مربعة
                        .aspectRatio(
                            1,
                            contentMode: .fit
                        )

                        // حدود المربع
                        .overlay {

                            Rectangle()
                                .stroke(
                                    Color.gray.opacity(0.35),
                                    lineWidth: 1
                                )
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("المربع \(index + 1)")
            }
        }

        .padding(Spacing.space16)

        // خلفية الشبكة
        .background(
            Color.glassBackground,
            in: RoundedRectangle(cornerRadius: 20)
        )

        // ظل الشبكة
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 10,
            y: 4
        )
    }

    // MARK: - Color Palette

    private var colorPalette: some View {

        HStack(spacing: Spacing.space4) {

            // الألوان الستة
            ForEach(
                viewModel.availableColors,
                id: \.self
            ) { color in

                Button {

                    // اختيار لون الرسم
                    viewModel.selectColor(color)

                } label: {

                    Circle()
                        .fill(Color(hex: color))

                        // إبراز اللون المختار
                        .overlay {

                            Circle()
                                .stroke(
                                    viewModel.selectedColor == color
                                        ? Color.textPrimary
                                        : Color.white,
                                    lineWidth: 2
                                )
                        }

                        .frame(width: 34, height: 34)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("اختيار اللون \(color)")
            }

            Spacer(minLength: 0)

            // زر التراجع
            Button {

                viewModel.undo()

            } label: {

                Text("تراجع")
                    .font(.dailyMinutesStyle)
                    .foregroundStyle(Color.textPrimary)

                    // منع النص من النزول لسطرين
                    .lineLimit(1)
                    .fixedSize(
                        horizontal: true,
                        vertical: false
                    )

                    .padding(.horizontal, Spacing.space12)
                    .frame(height: 38)

                    .overlay {

                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                Color.textPrimary.opacity(0.4),
                                lineWidth: 1
                            )
                    }
            }
            .buttonStyle(.plain)

            // تعطيل التراجع عندما لا يوجد تغيير سابق
            .disabled(!viewModel.canUndo)
            .opacity(viewModel.canUndo ? 1 : 0.5)
        }
    }

    // MARK: - Reflection Section

    private var reflectionSection: some View {

        VStack(spacing: Spacing.space16) {

            // سؤال معنى التصميم
            Text("ما المعنى خلف هذا الرمز؟")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            // حقل كتابة إجابة المستخدم
            TextField(
                "سجّل جوابك",
                text: $viewModel.answer
            )
            .font(.titleCards)
            .foregroundStyle(Color.textPrimary)
            .multilineTextAlignment(.trailing)

            .padding(Spacing.space16)

            .background(
                Color.glassBackground,
                in: Capsule()
            )

            .focused($isAnswerFocused)
            .submitLabel(.done)
        }
    }

    // MARK: - Finish Button

    private var finishButton: some View {

        PrimaryButton(
            title: "أنهيت",

            // الزر يتفعل بعد الرسم وكتابة الإجابة
            isDisabled: !viewModel.canFinish || isFinishing
        ) {

            // منع تسجيل الإنجاز أكثر من مرة
            guard !isFinishing else {
                return
            }

            isFinishing = true

            // إغلاق لوحة المفاتيح
            isAnswerFocused = false

            // حفظ تصميم المستخدم
            let saved = viewModel.save()

            // إذا فشل الحفظ، نسمح بالمحاولة مجددًا
            guard saved else {

                print("Failed to save Art Create")

                isFinishing = false
                return
            }

            // تسجيل إنجاز نشاط الفن
            StorageService().recordCompletedActivity(
                interest: .art
            )

            // الرجوع إلى الشاشة الرئيسية
            appRouter.popToRoot()
        }
    }

    // MARK: - Instructions Content

    private var instructionsContent: some View {

        VStack(spacing: Spacing.space24) {

            // عنوان نافذة التعليمات
            Text("طريقة أداء النشاط")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            // وصف النشاط
            Text("تمرين لربط الجانب البصري بالمعنى الشعوري")
                .font(.titleCards)
                .foregroundStyle(Color.appSecondary)
                .multilineTextAlignment(.center)

            // خطوات أداء النشاط
            VStack(
                alignment: .leading,
                spacing: Spacing.space16
            ) {

                instructionRow(
                    number: 1,
                    text: "اختر فكرة أو معلومة تعلمتها اليوم، وتخيّل نمطًا هندسيًا مستوحى من معناها وألوانها."
                )

                instructionRow(
                    number: 2,
                    text: "اختر الألوان المناسبة، واستخدم المربعات لتصميم رمز يعبّر عن الفكرة."
                )

                instructionRow(
                    number: 3,
                    text: "بعد الانتهاء، تأمل الرمز واكتب المعنى خلفه. غدًا حاول تذكّر الفكرة من الرمز."
                )
            }

            Spacer(minLength: 0)

            // زر إغلاق نافذة التعليمات
            PrimaryButton(title: "فهمت") {

                showInstructions = false
            }
        }

        .padding(Spacing.pageMargin)

        .background(
            Color.pageBackground.ignoresSafeArea()
        )

        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Instruction Row

    private func instructionRow(
        number: Int,
        text: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: Spacing.space12
        ) {

            // رقم الخطوة
            Text("\(number)")
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)

                .frame(width: 30, height: 30)

                .background(
                    Color.actionPrimary,
                    in: Circle()
                )

            // وصف الخطوة
            Text(text)
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)

                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
    }

} // نهاية struct ArtCreateView

// MARK: - Preview

#Preview {

    // مدير تنقل تجريبي
    let router = AppRouter()

    NavigationStack(
        path: Binding(
            get: { router.path },
            set: { router.path = $0 }
        )
    ) {

        // شاشة رئيسية مؤقتة لاختبار التنقل
        VStack(spacing: 20) {

            Text("الرئيسية")
                .font(.title)

            Button("افتح نشاط الفن") {

                router.push(.activity(.art))
            }
        }

        .navigationDestination(for: AppRoute.self) { route in

            switch route {

            case .activity:
                ArtCreateView()

            case .settings:
                Text("الإعدادات")
            }
        }
    }

    // تمرير مدير التنقل إلى الواجهة
    .environment(router)

    // تفعيل الاتجاه العربي
    .environment(\.layoutDirection, .rightToLeft)
}
