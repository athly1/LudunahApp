
import SwiftUI

/// Displays a gaming learning activity as a sequence of cards.
struct gameLearnView: View {

    // MARK: - State

    @StateObject private var viewModel: GamingLearnViewModel
    @State private var didFinish = false

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - Initialization

    init(activityID: String? = nil) {
        _viewModel = StateObject(
            wrappedValue: GamingLearnViewModel(activityID: activityID)
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // MARK: Header

                ActivityHeader(
                    interestTitle: "الألعاب الإلكترونية",
                    interestColor: .gamingChip,
                    stepTitle: "تعلّم",
                    stepIcon: "lightbulb.max",
                    onBack: {
                        previousCardOrDismiss()
                    }
                )
                .padding(.horizontal, Spacing.pageMargin)

                // MARK: Progress

                ProgressView(
                    value: viewModel.totalCards == 0
                        ? 0
                        : viewModel.currentProgress,
                    total: Double(max(viewModel.totalCards, 1))
                )
                .scaleEffect(y: 1.5)
                .tint(.actionPrimary)
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.top, Spacing.pageMargin)

                // MARK: Title

                Text(viewModel.title)
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.chipHeight)
                    .padding(.bottom, Spacing.headerTitleOffset + 40)

                // MARK: Learning Cards

                CardsFlowView(
                    iconColor: .mapSequers,
                    iconActivityBackground: .gamingTint,
                    cards: viewModel.cards,
                    index: viewModel.index,
                    onNext: {
                        nextCard()
                    }
                )

                // MARK: Finish

                if viewModel.isLastCard {
                    PrimaryButton(title: "انتهيت") {
                        finishActivity()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.headerTitleOffset)
                    .padding(.bottom, Spacing.pageMargin)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Navigation

    private func previousCardOrDismiss() {
        guard viewModel.index > 0 else {
            dismiss()
            return
        }

        withAnimation {
            viewModel.index -= 1
        }
    }

    private func nextCard() {
        guard viewModel.index < viewModel.totalCards - 1 else {
            return
        }

        withAnimation {
            viewModel.index += 1
        }
    }

    // MARK: - Completion

    private func finishActivity() {
        guard !didFinish, viewModel.isLastCard else {
            return
        }

        didFinish = true

        StorageService().recordCompletedActivity(
            interest: .gaming
        )

        dismiss()
    }
}

#Preview {
    gameLearnView()
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}
