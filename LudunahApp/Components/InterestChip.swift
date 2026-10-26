// InterestChip.swift - selectable capsule for one interest.
// A View showing the interest icon and title in a capsule.
// Inputs: interest, isSelected, action.
// Filled color when selected, light color when not.
// Used by: OnboardingView, SettingsView.
import SwiftUI


struct InterestChip: View {

    // The interests the user picked (empty at start)
    @State private var selectedInterests: Set<Interest> = []

    // The most the user can pick
    let maxSelections = 3

    var body: some View {

        // Puts chips side by side and wraps to a new line when full
        FlowLayout(spacing: Spacing.space8) {

            // Make one chip for every interest in the enum
            ForEach(Interest.allCases) { interest in

                InterestOneChip(
                    interest: interest,
                    // Is this interest in the set? → selected look
                    isSelected: selectedInterests.contains(interest)
                ) {
                    // When tapped → add or remove it
                    toggle(interest)
                }
            }
        }
    }

    // Selects or deselects one interest
    private func toggle(_ interest: Interest) {
        if selectedInterests.contains(interest) {
            // Already picked → remove it
            selectedInterests.remove(interest)
        } else if selectedInterests.count < maxSelections {
            // Not picked and still room → add it
            selectedInterests.insert(interest)
        }
    }
}


struct InterestOneChip: View {
    
    let interest: Interest
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        
        // generating the buttons shaped as chips for the interests
        
        Button(action: action) {
            Text(interest.title)
                .font(.titleCards)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.space16)
                .padding(.vertical, Spacing.space12)
                .background(isSelected ? Color.blue.opacity(0.2) : .clear, in: Capsule())
                .overlay(
                    Capsule().stroke(Color.gray.opacity(0.9), lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(.plain)
    }
}


struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0, widest: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            widest = max(widest, x - spacing)
        }
        return CGSize(width: widest, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}


#Preview {
    InterestChip()
              .environment(\.locale, Locale(identifier: "ar"))
              .environment(\.layoutDirection, .rightToLeft)
      }


