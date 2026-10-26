// ActivityHeader.swift - title + back + chips.
//
// Contains:
// - A View with a back button, the interest title, and one chip per ActivityStep.
// - The current and completed steps are highlighted.
// - Inputs: interest, current step, back action.
//
// Used by: ActivityFlowView.

import SwiftUI

// The top part that repeats on every activity screen:
// back button + page title, then the interest chip + the step chip.
struct ActivityHeader: View {

    // Page title (same on every activity screen, so it's a constant)
    let pageTitle: String = "النشاط اليومي"

    // Interest chip: the screen passes its text and its color (e.g. gaming)
    var interestTitle: String
    var interestColor: Color

    // Step chip when learn: the screen passes its text and SF Symbol name
    var stepTitle: String
    var stepIcon: String

    // What the back button does, passed in by the screen using the header
    // (defaults to doing nothing so the screen can leave it out for now)
    var onBack: () -> Void = {}

    var body: some View {
        // VStack = items stacked top to bottom: first row, then the chips row
        VStack(spacing: Spacing.space16) {

            // Row 1: back button + page title
            HStack {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 12, weight: .bold))
                }
                .buttonStyle(.glass)
                .frame(width: 37, height: 37)

                // maxWidth: .infinity lets the title take the remaining space,
                // and alignment: .center keeps it in the middle of that space
                Text(pageTitle)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            // Row 2: the two chips side by side
            HStack(spacing: Spacing.space8) {

                // Interest chip (its color comes from the screen)
                Text(interestTitle)
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, Spacing.space12)
                    .padding(.vertical, Spacing.space8)
                    .background(interestColor)
                    .cornerRadius(999) // a huge radius turns the box into a capsule

                // Step chip (always the app's primary color)
                Label(stepTitle, systemImage: stepIcon)
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, Spacing.space12)
                    .padding(.vertical, Spacing.space8)
                    .background(Color.actionPrimary)
                    .cornerRadius(999)
            }
        }
    }
}

#Preview {
    ActivityHeader(
        interestTitle: "الالعاب الالكترونيه",
        interestColor: .gamingTint,
        stepTitle: "تعلّم",
        stepIcon: "lightbulb.max"
    )
    // Preview in Arabic, right-to-left
    .environment(\.locale, Locale(identifier: "ar"))
    .environment(\.layoutDirection, .rightToLeft)
}
