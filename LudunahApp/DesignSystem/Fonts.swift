// Fonts.swift - all app fonts.
//
// Contains:
// - Text styles: largeTitle, title, headline, body, caption.
// - Based on system text styles so Dynamic Type works.
// - If you add a custom font, add it to the project and Info.plist first.
//
// Used by: all views and components.
// Learn: Font.TextStyle, Dynamic Type, custom fonts
import SwiftUI

// MARK: - App Colors
extension Color {
    static let appPrimary = Color(hex: "#6A4E2A")
    static let appSecondary = Color(hex: "#927B63")
}

// MARK: - App Fonts
extension Font {
    /// حجم 16 - Bold (Alexandria)
    static let popupTitle = Font.custom("Alexandria", size: 16).weight(.bold)
    
    /// حجم 17 - SemiBold (Alexandria)
    static let primaryButton = Font.custom("Alexandria", size: 17).weight(.semibold)
    
    /// حجم 18 - Bold (thmanyahsans)
    static let supTitle1 = Font.custom("thmanyah sans",size: 18).weight(.bold)
    
    /// حجم 18 - Bold (thmanyahsans)
    static let supTitle2 = Font.custom("thmanyah sans",size: 18).weight(.regular)
    
    /// حجم 10 - Medium (Alexandria)
    static let suptitleCards = Font.custom("Alexandria", size: 10).weight(.medium)
    
    /// حجم 14 - Medium (Alexandria)
    static let titleCards = Font.custom("Alexandria", size: 14).weight(.medium)
    
    /// حجم 24 - Bold (thmanyahsans)
    static let title1Heading = Font.custom("thmanyah sans",size: 24).weight(.bold)
    
    /// حجم 12 - Regular (Alexandria)
    static let dailyMinutesStyle = Font.custom("Alexandria", size: 12).weight(.regular)
    
    // Challenge card typography
    static let challengeCardTitle =
        Font.custom("Alexandria", size: 14).weight(.medium)

    static let challengeCardSubtitle =
        Font.custom("Alexandria", size: 12).weight(.regular)

}

// MARK: - Helper for Hex Colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 1)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
