import SwiftUI

// 🔒 Team agreement: use these values instead of hard-coded colors, fonts, and spacing.
enum Theme {
    enum Colors {
        static let primary = Color.indigo
        static let background = Color.indigo.opacity(0.05)
        static let card = Color.primary.opacity(0.06)
        static let textSecondary = Color.secondary

        static let gaming = Color.purple
        static let sport = Color.green
        static let art = Color.orange

        static func color(for interest: Interest) -> Color {
            switch interest {
            case .gaming: gaming
            case .sport: sport
            case .art: art
            }
        }
    }

    enum Fonts {
        static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
        static let title = Font.system(.title2, design: .rounded, weight: .bold)
        static let headline = Font.system(.headline, design: .rounded)
        static let body = Font.system(.body, design: .rounded)
        static let caption = Font.system(.caption, design: .rounded)
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
    }
}

extension Interest {
    var color: Color { Theme.Colors.color(for: self) }
}
