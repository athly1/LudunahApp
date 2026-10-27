//
//  SportLearnViewModel 2.swift
//  LudunahApp
//
//  Created by Ghadi on 16/05/1448 AH.
//


import SwiftUI
import Combine

final class SportLearnViewModel: ObservableObject {
    @Published var index = 0
    @Published var cards: [ActivityCard] = []
    @Published var title = ""

    init() {
        let model = SportLearnModel()
        title = model.title
        cards = model.cards
    }

    var totalCards: Int {
        cards.count
    }

    var currentProgress: Double {
        totalCards == 0 ? 0 : Double(index + 1)
    }

    var isLastCard: Bool {
        totalCards > 0 && index == totalCards - 1
    }

    func nextCard() {
        guard index < totalCards - 1 else { return }
        index += 1
    }

    func previousCard() {
        guard index > 0 else { return }
        index -= 1
    }
}

struct SportLearnView: View {
    @StateObject private var viewModel = SportLearnViewModel()
    @Environment(\.dismiss) private var dismiss

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
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.chipHeight)
                    .padding(.bottom, Spacing.headerTitleOffset + 40)

                CardsFlowView(
                    iconColor: .sportFieldBall,
                    iconActivityBackground: .sportTint,
                    cards: viewModel.cards,
                    index: viewModel.index,
                    onNext: {
                        withAnimation {
                            viewModel.nextCard()
                        }
                    }
                )

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
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    SportLearnView()
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}
