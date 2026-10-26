// GamingLearnView.swift - Gaming "Learn" step.
//
// Contains:
// - A View that explains today's game idea and rules.
// - Reads its data from GamingLearnViewModel.
//
// Used by: ActivityFlowView (gaming, learn).

import SwiftUI


// a struct is ightweighted thing not a class and this one of type View Protocol
struct gameLearnView: View {
    
    //progress bar
    var currentCard: Double = 1
    var totalCards: Double = 4
    
    //Learning Content
    var title: String = "مثال"
    
    //data var & let (considered its attributes and can be passed to the view when its called), Swift auto-creates its init
    //state (properites tht lesson for changes, owned by this view and it the values that change, so lessiong for any changes)
    
    // the properity veiw struct must hold which holds all that appears in screen
    
    //having 'some' View makes the type decided at run time where the body cah retruend any builded screen elements witouh having to complay to spcesif type
    var body: some View {
        ZStack{
            List(){
                // Modifiers on a Section are applied to every row inside it,
                // so the clear background + hidden separator are written once.
                Section {
                // Shared header: back button + page title + the 2 chips
                // (lives in Components/ActivityHeader.swift)
                ActivityHeader(
                    interestTitle: "الألعاب الإلكترونية",
                    interestColor: .gamingChip,
                    stepTitle: "تعلّم",
                    stepIcon: "lightbulb.max",
                    onBack: {
                        //Action
                    }
                )

                // Progress bar: how many learning cards the user has gone through
                ProgressView(value: currentCard,total:totalCards)
                    .scaleEffect(y: 1.5) // makes the bar a bit thicker
                    .tint(.actionPrimary)

                // Title of today's learning topic
                Text(title)
                    .foregroundColor(.textPrimary)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                // 24pt safe space on the left and right of every row
                .listRowInsets(.horizontal, Spacing.pageMargin)
                // Remove the List's own extra side margins,
                // so the space on each side is exactly the 24 above
                
                //FIX THIS REPLACE
                .listSectionMargins(.horizontal, 0)

            }
            // Hide the List's default gray background so the page background shows through
            .scrollContentBackground(.hidden)

        }.background(Color.pageBackground) // page background color from the design system
    }
  
}

#Preview {
          gameLearnView()
              .environment(\.locale, Locale(identifier: "ar"))
              .environment(\.layoutDirection, .rightToLeft)
      }



