import SwiftUI

/// A selectable capsule representing one interest.
struct InterestChip: View {
    let interest: Interest
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(interest.title, systemImage: interest.symbol)
                .font(Theme.Fonts.headline)
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
                .foregroundStyle(isSelected ? Color.white : interest.color)
                .background(isSelected ? interest.color : interest.color.opacity(0.12), in: .capsule)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HStack {
        InterestChip(interest: .gaming, isSelected: true) {}
        InterestChip(interest: .sport, isSelected: false) {}
    }
}
