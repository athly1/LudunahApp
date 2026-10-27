
// ArtCreateView.swift - واجهة نشاط ابتكر في الفن السعودي.
//
// Contains:
// - Shared ActivityHeader with back button.
// - Interactive 5x5 pixel grid.
// - Six-color palette and undo button.
// - Reflection question and answer field.
// - Instructions bottom sheet.
// - Save button and success alert.
//
// Used by: ActivityFlowView (art, create).
// Learn: @State, @Environment, @FocusState,
//       LazyVGrid, Button, sheet, alert, dismiss.

import SwiftUI

// MARK: - Art Create View

// واجهة نشاط صمّم رمز يحكي يومك
struct ArtCreateView: View {

    // الاحتفاظ بمنطق النشاط وحالة الرسم
    @State private var viewModel = ArtCreateViewModel()

    // الرجوع للشاشة السابقة
    @Environment(\.dismiss) private var dismiss

    // التحكم في ظهور نافذة التعليمات
    @State private var showInstructions = false

    // التحكم في ظهور رسالة الحفظ
    @State private var showSuccessAlert = false

    // معرفة هل حقل الإجابة نشط
    @FocusState private var isAnswerFocused: Bool

    // إعداد أعمدة شبكة الرسم الخمسة
    private let gridColumns = Array(
        repeating: GridItem(.flexible(), spacing: 3),
        count: 5
    )

    // MARK: - Body

    var body: some View {

        // يسمح بتمرير الصفحة إذا كان المحتوى طويلًا
        ScrollView {

            // ترتيب عناصر النشاط من الأعلى للأسفل
            VStack(spacing: Spacing.space24) {

                // هيدر النشاط المشترك مع باقي شاشات الفريق
                ActivityHeader(
                    interestTitle: "الفن السعودي",
                    interestColor: .artChipBackground,
                    stepTitle: "ابتكر",
                    stepIcon: "sparkles",
                    onBack: {
                        // الرجوع للشاشة السابقة
                        dismiss()
                    }
                )

                // عنوان التحدي وزر المعلومات
                activityTitle

                // شبكة المربعات
                pixelGrid

                // الألوان وزر التراجع
                colorPalette

                // سؤال معنى الرمز
                reflectionSection
            }
            .padding(.horizontal, Spacing.pageMargin)
            .padding(.top, Spacing.space16)
            .padding(.bottom, Spacing.space24)
        }

        // وضع زر أنهيت أسفل الشاشة
        .safeAreaInset(edge: .bottom) {

            finishButton
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.vertical, Spacing.space8)
                .background(Color.pageBackground)
        }

        // خلفية لُدُونه
        .background(Color.pageBackground.ignoresSafeArea())

        // إخفاء الهيدر الافتراضي لأن ActivityHeader يحل مكانه
        .toolbar(.hidden, for: .navigationBar)

        // اتجاه الواجهة عربي
        .environment(\.layoutDirection, .rightToLeft)

        // MARK: - Instructions Sheet

        // فتح نافذة طريقة أداء النشاط
        .sheet(isPresented: $showInstructions) {

            instructionsContent
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }

        // MARK: - Success Alert

        // إظهار رسالة نجاح حفظ التصميم
        .alert(
            "تم حفظ التصميم",
            isPresented: $showSuccessAlert
        ) {
            Button("حسنًا", role: .cancel) {}
        } message: {
            Text("تم حفظ رمزك بنجاح.")
        }
    }

    // MARK: - Activity Title

    // عنوان النشاط مع زر عرض التعليمات
    private var activityTitle: some View {

        HStack(spacing: Spacing.space8) {

            // عنوان التحدي
            Text("صمّم رمز يحكي يومك")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            // زر المعلومات
            Button {

                // إظهار نافذة التعليمات
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

    // شبكة مربعات قابلة للتلوين
    private var pixelGrid: some View {

        LazyVGrid(
            columns: gridColumns,
            spacing: 3
        ) {

            // إنشاء مربع لكل عنصر في المصفوفة
            ForEach(
                viewModel.pattern.cellColors.indices,
                id: \.self
            ) { index in

                Button {

                    // إغلاق لوحة المفاتيح عند الرسم
                    isAnswerFocused = false

                    // تلوين المربع المحدد
                    viewModel.paintCell(at: index)

                } label: {

                    Rectangle()

                        // اللون المحفوظ لهذا المربع
                        .fill(
                            Color(
                                hex: viewModel.pattern.cellColors[index]
                            )
                        )

                        // المحافظة على شكل مربع
                        .aspectRatio(1, contentMode: .fit)

                        // إضافة حدود خفيفة
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

        // المسافة الداخلية حول المربعات
        .padding(Spacing.space16)

        // خلفية الشبكة
        .background(
            Color.glassBackground,
            in: RoundedRectangle(cornerRadius: 20)
        )

        // الظل الموجود في التصميم
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 10,
            y: 4
        )
    }

    // MARK: - Color Palette

    // عرض لوحة الألوان وزر التراجع
    private var colorPalette: some View {

        HStack(spacing: Spacing.space4) {

            // إنشاء دائرة لكل لون متاح
            ForEach(
                viewModel.availableColors,
                id: \.self
            ) { color in

                Button {

                    // تحديث اللون المستخدم في الرسم
                    viewModel.selectColor(color)

                } label: {

                    Circle()

                        // تعبئة الدائرة باللون
                        .fill(Color(hex: color))

                        // تحديد اللون المختار
                        .overlay {

                            Circle()
                                .stroke(
                                    viewModel.selectedColor == color
                                        ? Color.textPrimary
                                        : Color.white,
                                    lineWidth: 2
                                )
                        }

                        // حجم دوائر الألوان
                        .frame(width: 34, height: 34)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("اختيار اللون \(color)")
            }

            // استخدام المساحة المتبقية عند توفرها
            Spacer(minLength: 0)

            // زر التراجع
            Button {

                // العودة لآخر حالة للشبكة
                viewModel.undo()

            } label: {

                Text("تراجع")
                    .font(.dailyMinutesStyle)
                    .foregroundStyle(Color.textPrimary)

                    // منع ظهور النص على سطرين
                    .lineLimit(1)
                    .fixedSize(
                        horizontal: true,
                        vertical: false
                    )

                    .padding(.horizontal, Spacing.space12)
                    .frame(height: 38)

                    // حدود الزر
                    .overlay {

                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                Color.textPrimary.opacity(0.4),
                                lineWidth: 1
                            )
                    }
            }
            .buttonStyle(.plain)

            // منع التراجع عند عدم وجود خطوات
            .disabled(!viewModel.canUndo)

            // تقليل الشفافية عند التعطيل
            .opacity(viewModel.canUndo ? 1 : 0.5)
        }
    }

    // MARK: - Reflection Section

    // سؤال المستخدم عن معنى التصميم
    private var reflectionSection: some View {

        VStack(spacing: Spacing.space16) {

            // سؤال التأمل
            Text("ما المعنى خلف هذا الرمز؟")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            // حقل كتابة الإجابة
            TextField(
                "سجّل جوابك",
                text: $viewModel.answer
            )
            .font(.titleCards)
            .foregroundStyle(Color.textPrimary)
            .multilineTextAlignment(.trailing)

            // المسافة داخل الحقل
            .padding(Spacing.space16)

            // خلفية حقل الإجابة
            .background(
                Color.glassBackground,
                in: Capsule()
            )

            // ربط الحقل بحالة لوحة المفاتيح
            .focused($isAnswerFocused)

            // شكل زر الإدخال في الكيبورد
            .submitLabel(.done)
        }
    }

    // MARK: - Finish Button

    // زر إنهاء التصميم
    private var finishButton: some View {

        PrimaryButton(
            title: "أنهيت",

            // يتفعّل بعد تلوين مربع وكتابة معنى
            isDisabled: !viewModel.canFinish
        ) {

            // إغلاق لوحة المفاتيح
            isAnswerFocused = false

            // حفظ التصميم
            let saved = viewModel.save()

            // عرض رسالة نجاح الحفظ
            if saved {
                showSuccessAlert = true
            }
        }
    }

    // MARK: - Instructions Content

    // النافذة التي تشرح طريقة أداء النشاط
    private var instructionsContent: some View {

        VStack(spacing: Spacing.space24) {

            // عنوان النافذة
            Text("طريقة أداء النشاط")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            // وصف الهدف من النشاط
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

            // زر إغلاق التعليمات
            PrimaryButton(title: "فهمت") {

                // إغلاق نافذة التعليمات
                showInstructions = false
            }
        }

        // هوامش المحتوى
        .padding(Spacing.pageMargin)

        // خلفية النافذة
        .background(Color.pageBackground.ignoresSafeArea())

        // الاتجاه العربي
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Instruction Row

    // صف يمثل خطوة واحدة في التعليمات
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

            // نص الخطوة
            Text(text)
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
    }
}

// MARK: - Preview

// تجربة زر الرجوع بوجود شاشة سابقة
#Preview {

    NavigationStack {

        NavigationLink("افتح نشاط الفن") {

            ArtCreateView()
        }
    }
    .environment(\.layoutDirection, .rightToLeft)
}
