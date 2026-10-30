import SwiftUI

struct SportLearnView: View {
    @StateObject private var viewModel: SportLearnViewModel

    // activityID: النشاط المختار من الهوم
    init(activityID: String? = nil) {
        _viewModel = StateObject(
            wrappedValue: SportLearnViewModel(activityID: activityID)
        )
    }
    @Environment(\.dismiss) private var dismiss

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

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                ActivityHeader(
                    interestTitle: "الرياضة",
                    interestColor: .sportTint,
                    stepTitle: "تعلّم",
                    stepIcon: "lightbulb.max",
                    onBack: {
                        if viewModel.index > 0 {
                            withAnimation {
                                viewModel.previousCard()
                            }
                        } else {
                            dismiss()
                        }
                    }
                )
                .padding(.horizontal, Spacing.pageMargin)

                ProgressView(
                    value: viewModel.currentProgress,
                    total: Double(max(viewModel.totalCards, 1))
                )
                .scaleEffect(y: 1.5)
                .tint(.actionPrimary)
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.top, Spacing.pageMargin)

                Text(viewModel.title)
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.chipHeight)
                    .padding(.bottom, Spacing.headerTitleOffset + 40)

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

                if viewModel.isLastCard {
                    PrimaryButton(title: "انتهيت") {
                        dismiss()
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
}

#Preview {
    SportLearnView()
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}
