import SwiftUI

struct SportCreateView: View {
    @StateObject private var viewModel: SportCreateViewModel
    @Environment(\.dismiss) private var dismiss

    let sport: SportPlan
    var onFinish: (SportCreateModel) -> Void = { _ in }

    init(
        sport: SportPlan = .football,
        onFinish: @escaping (SportCreateModel) -> Void = { _ in }
    ) {
        self.sport = sport
        self.onFinish = onFinish
        _viewModel = StateObject(
            wrappedValue: SportCreateViewModel(sport: sport)
        )
    }

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ActivityHeader(
                    interestTitle: "الرياضة",
                    interestColor: .sportTint,
                    stepTitle: "ابتكر",
                    stepIcon: "sparkles",
                    onBack: { dismiss() }
                )

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Spacing.space24) {
                        VStack(alignment: .leading, spacing: Spacing.space8) {
                            Text("جهّز خطتك التدريبية")
                                .font(.title1Heading)
                                .foregroundStyle(Color.textPrimary)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )

                            Text(sport.subtitle)
                                .font(.titleCards)
                                .foregroundStyle(Color.textPrimary)
                                .multilineTextAlignment(.leading)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        }
                        .padding(.top, Spacing.space24)

                        optionSection(
                            title: "نوع التمرين",
                            options: sport.exerciseTypes,
                            selection: $viewModel.model.exerciseType,
                            label: { $0.title }
                        )

                        optionSection(
                            title: "مستوى الصعوبة",
                            options: SportDifficulty.allCases,
                            selection: $viewModel.model.difficulty,
                            label: { $0.title }
                        )

                        optionSection(
                            title: "مساحة الملعب",
                            options: SportSpace.allCases,
                            selection: $viewModel.model.space,
                            label: { $0.title }
                        )

                        HStack(spacing: Spacing.space12) {
                            countPicker(
                                title: "عدد اللاعبين",
                                value: viewModel.model.playerCount,
                                range: 2...10,
                                onSelect: viewModel.setPlayerCount
                            )

                            countPicker(
                                title: "مدة التمرين",
                                value: viewModel.model.durationMinutes,
                                range: 1...30,
                                onSelect: viewModel.setDuration
                            )
                        }

                        VStack(alignment: .leading, spacing: Spacing.space8) {
                            Text("اسم الخطة")
                                .font(.supTitle1)
                                .foregroundStyle(Color.textPrimary)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )

                            TextField(
                                "اكتب اسم خطتك هنا",
                                text: $viewModel.model.planName
                            )
                            .font(.supTitle2)
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.leading)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, Spacing.space16)
                            .frame(height: 56)
                            .glassEffect(
                                .regular.interactive(),
                                in: Capsule()
                            )
                        }
                    }
                    .padding(.top, Spacing.space16)
                    .padding(.bottom, Spacing.space24)
                }

                PrimaryButton(title: "احفظ الخطة") {
                    viewModel.finish()
                    onFinish(viewModel.model)
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, Spacing.space12)
                .padding(.bottom, Spacing.space16)
            }
            .padding(.horizontal, Spacing.pageMargin)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    private func optionSection<Option: Identifiable & Equatable>(
        title: String,
        options: [Option],
        selection: Binding<Option>,
        label: @escaping (Option) -> String
    ) -> some View {
        VStack(alignment: .leading, spacing: Spacing.space8) {
            Text(title)
                .font(.supTitle1)
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 0) {
                ForEach(options) { option in
                    let isSelected = selection.wrappedValue == option

                    Button {
                        selection.wrappedValue = option
                    } label: {
                        Text(label(option))
                            .font(.supTitle2)
                            .foregroundStyle(
                                isSelected ? Color.white : Color.textPrimary
                            )
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background {
                                if isSelected {
                                    Capsule()
                                        .fill(Color.actionPrimary)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.space4)
            .glassEffect(.regular.interactive(), in: Capsule())
        }
    }

    private func countPicker(
        title: String,
        value: Int,
        range: ClosedRange<Int>,
        onSelect: @escaping (Int) -> Void
    ) -> some View {
        HStack(spacing: Spacing.space8) {
            Menu {
                ForEach(Array(range), id: \.self) { option in
                    Button("\(option)") {
                        onSelect(option)
                    }
                }
            } label: {
                HStack(spacing: Spacing.space8) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))

                    Text("\(value)")
                        .font(.supTitle2)
                }
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .glassEffect(.regular.interactive(), in: Capsule())
            }

            Text(title)
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)
                .fixedSize()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("Football") {
    SportCreateView(sport: .football)
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}

#Preview("Padel") {
    SportCreateView(sport: .padel)
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}
