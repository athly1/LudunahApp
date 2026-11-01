
import SwiftUI

/// Displays a sports learning activity as a sequence of cards.
struct SportLearnView: View {

    // MARK: - State

    @StateObject private var viewModel: SportLearnViewModel
    @State private var didFinish = false

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - Initialization

    init(activityID: String? = nil) {
        _viewModel = StateObject(
            wrappedValue: SportLearnViewModel(activityID: activityID)
        )
    }

    // MARK: - Display Cards

    private var displayCards: [ActivityCard] {
        viewModel.cards.map { card in
            ActivityCard(
                icon: systemIcon(for: card.icon),
                text: card.text
            )
        }
    }

    private func systemIcon(for icon: String) -> String {
        switch icon {
        case "hook":
            return "car"
        case "brain":
            return "brain.head.profile"
        case "study":
            return "book.closed"
        case "question":
            return "questionmark.circle"
        default:
            return icon
        }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // MARK: Header

                ActivityHeader(
                    interestTitle: "الرياضة",
                    interestColor: .sportTint,
                    stepTitle: "تعلّم",
                    stepIcon: "lightbulb.max",
                    onBack: {
                        previousCardOrDismiss()
                    }
                )
                .padding(.horizontal, Spacing.pageMargin)

                // MARK: Progress

                ProgressView(
                    value: viewModel.currentProgress,
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.chipHeight)
                    .padding(.bottom, Spacing.headerTitleOffset + 40)

                // MARK: Learning Cards

                CardsFlowView(
                    iconColor: .sportFieldBall,
                    iconActivityBackground: .sportTint,
                    cards: displayCards,
                    index: viewModel.index,
                    onNext: {
                        withAnimation {
                            viewModel.nextCard()
                        }
                    }
                )

                Spacer(minLength: 0)

                // MARK: Finish Button

                if viewModel.isLastCard {
                    PrimaryButton(title:  "اتمام التحدي") {
                        finishActivity()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.headerTitleOffset)
                    .padding(.bottom, Spacing.pageMargin)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    // MARK: - Navigation

    private func previousCardOrDismiss() {
        guard viewModel.index > 0 else {
            dismiss()
            return
        }

        withAnimation {
            viewModel.previousCard()
        }
    }

    // MARK: - Completion

    /// Records completion once before dismissing the activity.
    private func finishActivity() {
        guard !didFinish, viewModel.isLastCard else {
            return
        }

        didFinish = true

        StorageService().recordCompletedActivity(
            interest: .sport
        )

        dismiss()
    }
}

#Preview {
    SportLearnView()
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}
