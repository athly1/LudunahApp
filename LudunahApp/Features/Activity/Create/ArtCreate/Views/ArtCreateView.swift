
// ArtCreateView.swift - واجهة أنشطة ابتكر في الفن السعودي.
//
// Contains:
// - Random Art Create activity from Art.json.
// - Original 5x5 pixel grid design.
// - Six-color palette with undo button.
// - Three color mixing rounds.
// - Favorite color and creative naming.
// - Reflection question.
// - Instructions bottom sheet.
// - Fixed finish button.
//
// Used by: ActivityFlowView (art, create).
//
// Learn: @State, @FocusState, LazyVGrid,
//        @ViewBuilder, ForEach, Binding, sheet.


import SwiftUI

// MARK: - Art Create View

struct ArtCreateView: View {

    // MARK: - Properties

    // إدارة النشاطين من JSON
    @State private var viewModel: ArtCreateViewModel

    init(activityID: String? = nil) {
        _viewModel = State(
            initialValue: ArtCreateViewModel(
                activityID: activityID
            )
        )
    }

    // الرجوع وإغلاق النشاط
    @Environment(\.dismiss) private var dismiss

    // نافذة التعليمات
    @State private var showInstructions = false

    // لوحة المفاتيح
    @FocusState private var isAnswerFocused: Bool

    // منع تسجيل الإنجاز مرتين
    @State private var isFinishing = false

    // شبكة خمسة أعمدة
    private let gridColumns = Array(
        repeating: GridItem(.flexible(), spacing: 3),
        count: 5
    )

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.space24) {

                // MARK: - Shared Header

                ActivityHeader(
                    interestTitle: "الفن السعودي",
                    interestColor: .artChipBackground,
                    stepTitle: "ابتكر",
                    stepIcon: "sparkles",
                    onBack: {
                        dismiss()
                    }
                )

                if let activity = viewModel.activity {

                    // عنوان النشاط والمعلومات
                    activityTitle(activity.title)

                    // تحديد النشاط من JSON
                    if activity.id == "art-create-1" {

                        // تصميم الشبكة
                        gridActivity(activity)

                    } else if activity.id == "art-create-2" {

                        // مختبر الألوان
                        mixingActivity(activity)
                    }

                } else {
                    Text(
                        viewModel.errorMessage
                            ?? "لا يوجد نشاط متاح."
                    )
                    .font(.titleCards)
                    .foregroundStyle(Color.textPrimary)
                }
            }
            .padding(.horizontal, Spacing.pageMargin)
            .padding(.top, Spacing.space16)
            .padding(.bottom, Spacing.space24)
        }

        // MARK: - Fixed Bottom Button

        .safeAreaInset(edge: .bottom) {
            if viewModel.activity != nil {
                finishButton
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.vertical, Spacing.space8)
                    .background(Color.pageBackground)
            }
        }

        // MARK: - Design System

        .background(
            Color.pageBackground.ignoresSafeArea()
        )
        .toolbar(.hidden, for: .navigationBar)
        .environment(
            \.layoutDirection,
            .rightToLeft
        )

        // MARK: - Instructions Sheet

        .sheet(isPresented: $showInstructions) {
            instructionsContent
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Activity Title

    private func activityTitle(
        _ title: String
    ) -> some View {

        HStack(spacing: Spacing.space8) {

            Text(title)
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            Button {
                showInstructions = true
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.textPrimary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("طريقة أداء النشاط")

            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }

    // MARK: - Grid Activity

    // النشاط الأول: صمم رمز يحكي يومك
    private func gridActivity(
        _ activity: ArtCreateModel
    ) -> some View {

        VStack(spacing: Spacing.space24) {

            // شبكة الرسم
            pixelGrid(activity)

            // الألوان وزر التراجع
            colorPalette(activity)

            // سؤال معنى الرمز
            reflectionSection(activity)
        }
    }

    // MARK: - Pixel Grid

    private func pixelGrid(
        _ activity: ArtCreateModel
    ) -> some View {

        LazyVGrid(
            columns: gridColumns,
            spacing: 3
        ) {

            // عرض المربعات الخمسة والعشرين
            ForEach(
                viewModel.grid.indices,
                id: \.self
            ) { index in

                Button {
                    // إغلاق لوحة المفاتيح
                    isAnswerFocused = false

                    // تلوين المربع
                    viewModel.paintCell(at: index)

                } label: {
                    Rectangle()
                        .fill(
                            cellColor(
                                at: index,
                                colors: activity.colors
                            )
                        )
                        .aspectRatio(
                            1,
                            contentMode: .fit
                        )
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
        .background(
            Color.glassBackground,
            in: RoundedRectangle(cornerRadius: 20)
        )
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 10,
            y: 4
        )
    }

    // MARK: - Cell Color

    private func cellColor(
        at index: Int,
        colors: [String]
    ) -> Color {

        guard viewModel.grid.indices.contains(index),
              let colorIndex = viewModel.grid[index],
              colors.indices.contains(colorIndex) else {
            return .white
        }

        return Color(hex: colors[colorIndex])
    }

    // MARK: - Color Palette

    private func colorPalette(
        _ activity: ArtCreateModel
    ) -> some View {

        HStack(spacing: Spacing.space4) {

            // الألوان الستة
            ForEach(
                activity.colors.indices,
                id: \.self
            ) { index in

                Button {
                    viewModel.selectedColorIndex = index

                } label: {
                    Circle()
                        .fill(
                            Color(hex: activity.colors[index])
                        )
                        .overlay {
                            Circle()
                                .stroke(
                                    viewModel.selectedColorIndex == index
                                        ? Color.textPrimary
                                        : Color.white,
                                    lineWidth: 2
                                )
                        }
                        .frame(width: 34, height: 34)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(
                    "اختيار اللون \(index + 1)"
                )
            }

            Spacer(minLength: 0)

            // MARK: - Undo Button

            Button {
                viewModel.undo()

            } label: {
                Text("تراجع")
                    .font(.dailyMinutesStyle)
                    .foregroundStyle(Color.textPrimary)
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
            .disabled(!viewModel.canUndo)
            .opacity(viewModel.canUndo ? 1 : 0.5)
        }
    }

    // MARK: - Reflection Section

    private func reflectionSection(
        _ activity: ArtCreateModel
    ) -> some View {

        VStack(spacing: Spacing.space16) {

            Text(activity.question)
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            TextField(
                "سجّل جوابك",
                text: $viewModel.reflection
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

    // MARK: - Mixing Activity

    // النشاط الثاني: مختبر الألوان
    @ViewBuilder
    private func mixingActivity(
        _ activity: ArtCreateModel
    ) -> some View {

        if viewModel.isMixingComplete {

            // بعد انتهاء الجولات
            favoriteColorContent(activity)

        } else if let round = viewModel.currentRound {

            VStack(spacing: Spacing.space24) {

                // MARK: - Round Progress

                Text(
                    "الجولة \(viewModel.currentRoundNumber) من \(viewModel.totalRounds)"
                )
                .font(.supTitle2)
                .foregroundStyle(Color.textPrimary)

                ProgressView(
                    value: Double(viewModel.roundIndex),
                    total: Double(
                        max(viewModel.totalRounds, 1)
                    )
                )
                .tint(Color.actionPrimary)

                // MARK: - Mixing Card

                VStack(spacing: Spacing.space16) {

                    Text("وش تتوقع ينتج عن مزج اللونين؟")
                        .font(.titleCards)
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.center)

                    // اللونان الأساسيان
                    HStack(spacing: Spacing.space24) {
                        ForEach(
                            round.colors,
                            id: \.self
                        ) { color in
                            Circle()
                                .fill(Color(hex: color))
                                .frame(
                                    width: 85,
                                    height: 85
                                )
                        }
                    }

                    Image(systemName: "arrow.down")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.textPrimary)

                    // MARK: - Result

                    if viewModel.isRevealed {

                        Circle()
                            .fill(
                                Color(hex: round.resultColor)
                            )
                            .frame(
                                width: 100,
                                height: 100
                            )

                        Text("النتيجة: \(round.answer)")
                            .font(.titleCards)
                            .foregroundStyle(Color.textPrimary)

                        if viewModel.selectedAnswer == round.answer {

                            Text("توقعك صحيح!")
                                .font(.supTitle2)
                                .foregroundStyle(Color.textPrimary)

                        } else {

                            Text(
                                "توقعك كان: \(viewModel.selectedAnswer ?? "")"
                            )
                            .font(.supTitle2)
                            .foregroundStyle(Color.textPrimary)
                        }

                    } else {

                        Circle()
                            .fill(Color.pageBackground)
                            .frame(
                                width: 100,
                                height: 100
                            )
                            .overlay {
                                Image(systemName: "questionmark")
                                    .font(.system(size: 34))
                                    .foregroundStyle(Color.textPrimary)
                            }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(Spacing.space24)
                .background(
                    Color.glassBackground,
                    in: RoundedRectangle(cornerRadius: 20)
                )

                // MARK: - Answer Options

                VStack(spacing: Spacing.space12) {

                    ForEach(
                        round.options,
                        id: \.self
                    ) { option in

                        Button {
                            viewModel.selectAnswer(option)

                        } label: {
                            HStack {
                                Text(option)
                                    .font(.titleCards)

                                Spacer()

                                if viewModel.selectedAnswer == option {
                                    Image(
                                        systemName: "checkmark.circle.fill"
                                    )
                                }
                            }
                            .foregroundStyle(Color.textPrimary)
                            .padding(Spacing.space16)
                            .frame(maxWidth: .infinity)
                            .background(
                                viewModel.selectedAnswer == option
                                    ? Color.artChipBackground
                                    : Color.glassBackground,
                                in: RoundedRectangle(
                                    cornerRadius: 14
                                )
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(viewModel.isRevealed)
                    }
                }

                // MARK: - Round Controls

                if viewModel.isRevealed {

                    PrimaryButton(
                        title: viewModel.isLastRound
                            ? "اختيار اللون المفضل"
                            : "الجولة التالية"
                    ) {
                        viewModel.nextRound()
                    }

                } else {

                    PrimaryButton(
                        title: "اكشف النتيجة",
                        isDisabled: viewModel.selectedAnswer == nil
                    ) {
                        viewModel.revealResult()
                    }
                }
            }
        }
    }

    // MARK: - Favorite Color

    // اختيار لون من نتائج الجولات الثلاث
    private func favoriteColorContent(
        _ activity: ArtCreateModel
    ) -> some View {

        VStack(spacing: Spacing.space24) {

            Text("اختر لونك المفضل من النتائج")
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)

            HStack(spacing: Spacing.space16) {

                ForEach(
                    activity.rounds.indices,
                    id: \.self
                ) { index in

                    Button {
                        viewModel.favoriteRoundIndex = index

                    } label: {
                        VStack(spacing: Spacing.space8) {

                            Circle()
                                .fill(
                                    Color(
                                        hex: activity.rounds[index].resultColor
                                    )
                                )
                                .frame(
                                    width: 65,
                                    height: 65
                                )
                                .padding(5)
                                .overlay {
                                    Circle()
                                        .stroke(
                                            viewModel.favoriteRoundIndex == index
                                                ? Color.actionPrimary
                                                : .clear,
                                            lineWidth: 2
                                        )
                                }

                            Text(activity.rounds[index].answer)
                                .font(.caption)
                                .foregroundStyle(Color.textPrimary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)

            // الاسم الإبداعي
            VStack(spacing: Spacing.space16) {

                Text(activity.question)
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                TextField(
                    "مثال: غروب الخيال",
                    text: $viewModel.inventedColorName
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
        .padding(Spacing.space16)
        .background(
            Color.glassBackground,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }

    // MARK: - Finish Button

    // يظهر بأسفل الشاشة لكلا النشاطين
    private var finishButton: some View {

        PrimaryButton(
            title: "أنهيت",
            isDisabled: !viewModel.canFinish || isFinishing
        ) {
            finishActivity()
        }
    }

    // MARK: - Instructions

    private var instructionsContent: some View {

        VStack(spacing: Spacing.space24) {

            Text("طريقة أداء النشاط")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            if let activity = viewModel.activity {

                Text(activity.description)
                    .font(.titleCards)
                    .foregroundStyle(Color.appSecondary)
                    .multilineTextAlignment(.center)

                ScrollView {
                    DoStepsCard(
                        howTo: activity.howTo,
                        stepRingColor: .artChipBackground
                    )
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

    // MARK: - Finish Activity

    private func finishActivity() {

        guard !isFinishing,
              viewModel.canFinish else {
            return
        }

        // منع تسجيل الإنجاز أكثر من مرة
        isFinishing = true

        // إغلاق لوحة المفاتيح
        isAnswerFocused = false

        // تسجيل إنجاز نشاط الفن
        StorageService().recordCompletedActivity(
            interest: .art
        )

        // إغلاق النشاط
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    ArtCreateView()
        .environment(
            \.layoutDirection,
            .rightToLeft
        )
}
