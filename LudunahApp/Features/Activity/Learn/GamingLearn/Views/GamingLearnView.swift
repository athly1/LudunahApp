import SwiftUI

struct gameLearnView: View {

    //linking ViewModel, with it $ is used when using a projected value where binding happens in 2 way, where its binded with a published property
    
    //Note Use Use the $ when the var is @Binding when where the child view needs to change a value owned by its parent.
    @StateObject private var viewModel = GamingLearnViewModel()
    
    //Exit button
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
   

        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            // The main page is a VStack
            VStack(alignment: .leading,spacing:0) {

                // MARK: - Fixed Header, Progress, and Title

                // Shared header: back button + title + chips
                ActivityHeader(
                    interestTitle: "الألعاب الإلكترونية",
                    interestColor: .gamingChip,
                    stepTitle: "تعلّم",
                    stepIcon: "lightbulb.max",
                    onBack: {
                        if viewModel.index > 0 {
                            withAnimation {
                                viewModel.index -= 1
                            } }
                            else {
                                dismiss()
                            }
                        }                    
                )
                .padding(.horizontal, Spacing.pageMargin)

                // MARK: - Progress follows the index owned by this view.
                ProgressView(
                    value: viewModel.currentProgress,
                    total: Double(viewModel.totalCards)
                )
                .scaleEffect(y: 1.5) // Make the bar a bit thicker
                .tint(.actionPrimary)
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.top, Spacing.pageMargin)

                // MARK: - Title of today's learning topic
                Text(viewModel.title)
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.chipHeight)
                    .padding(.bottom, Spacing.headerTitleOffset + 40)

                // MARK: - Card Area
                
                // CardsFlowView contains the ScrollView
                CardsFlowView(
                    iconColor: .mapSequers,
                    iconActivityBackground: .gamingTint,
                    cards: viewModel.cards,
                    index: viewModel.index,
                    onNext: {
                        // Update the parent-owned index.
                        // The progress bar updates automatically.
                        func UpdateProgressBar(){
                            if viewModel.index < viewModel.totalCards - 1{
                                withAnimation {
                                    viewModel.index += 1
                                }
                            }
                        }
                    }
                )
                // MARK: - Bottom End Button

                //the button outside the ScrollView.
                // It stays at the bottom and takes the available width.
                if viewModel.isLastCard {
                    PrimaryButton(Title: "انتهيت") {
                        // Your finish action goes here.
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.headerTitleOffset)
                    .padding(.bottom, Spacing.pageMargin)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        // Keep the Arabic layout direction.
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    gameLearnView()
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}
