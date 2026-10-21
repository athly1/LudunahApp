import SwiftUI

/// Shows the current interest and where the user is in the Learn → Do → Create flow.
struct ActivityHeader: View {
    let interest: Interest
    let step: ActivityStep

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: interest.symbol)
                    .font(.title2)
                    .foregroundStyle(interest.color)
                    .accessibilityHidden(true)

                VStack(alignment: .leading) {
                    Text(interest.title)
                        .font(Theme.Fonts.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Text(step.title)
                        .font(Theme.Fonts.title)
                }
            }

            HStack(spacing: Theme.Spacing.xs) {
                ForEach(ActivityStep.allCases) { item in
                    Capsule()
                        .fill(item.rawValue <= step.rawValue ? interest.color : Theme.Colors.card)
                        .frame(height: 6)
                }
            }
            .accessibilityElement()
            .accessibilityLabel("Step \(step.rawValue + 1) of \(ActivityStep.allCases.count)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ActivityHeader(interest: .art, step: .practice)
        .padding()
}
