import SwiftUI

/// The main call-to-action button used across the app.
struct PrimaryButton: View {
    private let title: LocalizedStringKey
    private let systemImage: String?
    private let action: () -> Void

    init(_ title: LocalizedStringKey, systemImage: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Group {
                if let systemImage {
                    Label(title, systemImage: systemImage)
                } else {
                    Text(title)
                }
            }
            .font(Theme.Fonts.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.xs)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
    }
}

#Preview {
    VStack {
        PrimaryButton("Continue") {}
        PrimaryButton("Start", systemImage: "play.fill") {}
            .disabled(true)
    }
    .padding()
}
