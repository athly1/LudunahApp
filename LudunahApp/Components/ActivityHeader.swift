// this file has title + back + chips. The top part that repeats on every activity screen
// A struct view with a back button, the interest title, and one chip per Activity type based on energy level.
// Inputs: interest, activity type, back action.
// Used by: ActivityFlowView, Views of (create,learn,act)
import SwiftUI

struct ActivityHeader: View {

    // Page title
    let pageTitle: String = "النشاط اليومي"

    // Interest type chip
    var interestTitle: String
    var interestColor: Color

    // activity type chip
    var stepTitle: String
    var stepIcon: String

    // What the back button does, passed in by the screen using this header, (defaults to doing nothing so the screen can leave it out for now)
    var onBack: () -> Void = {}

    var body: some View {

        VStack(spacing: Spacing.space24) {

            // Row 1: back button + page title (ZStacked)
            // ZStack puts the title and the button on top of each other, so the title is centered on the whole screen width (not just the space left over next to the button).
            ZStack {
                Text(pageTitle)
                    .font(.title1Heading)
                    .foregroundColor(.textPrimary)

                HStack {
                    Button {
                        //Action
                        onBack()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    .buttonStyle(.glass)
                    .frame(width: 37, height: 37)

                    // Spacer pushes the button to the start edge (right side in Arabic), the safe area 24px is added where this struct is used by an Activity page not in here
                    Spacer()
                }
            }

            // Row 2 the two chips side by side
            HStack(spacing: Spacing.space8) {

                // Activity type chip
                // HStack instead of Label so the icon sits close to the text with 4 spacing
                HStack(spacing: Spacing.space4) {
                    Image(systemName: stepIcon)
                    Text(stepTitle)
                }
                    .font(.titleCards)
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, Spacing.space12)
                    .frame(height: Spacing.chipHeight)
                    .background(Color.actionPrimary)
                    .cornerRadius(999) // a huge radius turns the box into a capsule

                // Interest chip (its color comes from the screen uding this view struct)
                Text(interestTitle)
                    .font(.titleCards)
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, Spacing.space12)
                    .frame(height: Spacing.chipHeight)
                    .background(interestColor)
                    .cornerRadius(999)
            }
            // Takes the full width and line the chips up at the start edge
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


//Example to view it
#Preview {
    ActivityHeader(
        interestTitle: "الألعاب الإلكترونية",
        interestColor: .gamingChip,
        stepTitle: "تعلّم",
        stepIcon: "lightbulb.max"
    )
    
    //right-to-left
    .environment(\.locale, Locale(identifier: "ar"))
    .environment(\.layoutDirection, .rightToLeft)
}
