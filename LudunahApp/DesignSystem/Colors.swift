// Colors.swift - all app colors.
//
// Contains:
// - App colors: primary, background, card, primary text, secondary text.
// - One color per Interest: art, sport, gaming.
// - Read colors from Assets.xcassets (Brand folder) so they support dark mode.
// - Use these everywhere instead of hard-coded colors.
//
// Used by: all views and components.
// Learn: Color sets in the asset catalog, extensions on Color
// Colors.swift - All app colors.
// Contains organized UI design system colors for Ludunah.

import SwiftUI

extension Color {
    // 1. الألوان الأساسية للهوية والنصوص (Core UI)
    static let actionPrimary = Color("Ludunah/ActionPrimary")        // #C2D5E2
    static let textPrimary = Color("Ludunah/TextPrimary")            // #6A4E2A
    static let pageBackground = Color("Ludunah/PageBackground")      // #F4F2EC
    static let glassBackground = Color("Ludunah/GlassBackground")    // #FFFFFF
    static let interestCardBg = Color("Ludunah/InterestCardBg")      // #FFFAF8
    
    // 2. ألوان الرسوم والبيانات والخطوط (Charts & Elements)
    static let drawingLines = Color("Charts/DrawingLines")           // #FBF4F1
    static let emptyDaysChart = Color("Charts/EmptyDaysChart")       // #F0E2DC
    static let progressBarInactive = Color("Charts/ProgressInactive") // #EEE8DF
    static let calendarCurrentDay = Color("Charts/CalendarCurrent")   // #9AA5AC

    // 3. ألوان فئة الفن والتوقيت (Art & Timer)
    static let artPalette1 = Color("Art/Palette1")                  // #D69A84
    static let artPalette2 = Color("Art/Palette2")                  // #5F8A7A
    static let artTimerRing = Color("Art/TimerRing")                // #8A3A32
    static let artPalette3 = Color("Art/Palette3")                  // #D6934D
    static let artSunset = Color("Art/Sunset")                      // #E58C62
    
    // ظلال وخلفيات الفن (Art Tints)
    static let artTint1 = Color("Art/Tints/Art1")                   // #F4E4D8
    static let artTint2 = Color("Art/Tints/Art2")                   // #EBD3C3
    static let artTint3 = Color("Art/Tints/Art3")                   // #FFF5F2
    static let artChipBackground = Color("Art/Tints/ChipBg")        // #FBE1D3

    // 4. ألوان فئة الرياضة (Sport)
    static let sportFieldBall = Color("Sport/FieldBall")            // #1F5240
    static let sportChip = Color("Sport/Chip")                      // #A6C77E
    static let sportTint = Color("Sport/Tint")                      // #E4EFDD

    // 5. ألوان فئة الألعاب والخرائط (Gaming & Maps)
    static let mapSequers = Color("Gaming/MapSequers")              // #4A3A8C
    static let mapTimerRing = Color("Gaming/MapTimerRing")          // #5EC8D8
    static let gamingBadges = Color("Gaming/Badges")                // #A598E3
    static let gamingTint = Color("Gaming/Tint")                    // #E0F4F7
    static let gamingChip = Color("Gaming/Chip")                    // #DDD8F3
    
    // Energy levels
    static let energyLow = Color.artPalette1
    static let energyMedium = Color.artPalette3
    static let energyHigh = Color.sportFieldBall
    
    // Challenge card backgrounds
    static let challengeArtBadge = Color(hex: "#F7EBE1")
    static let challengeGamingBadge = Color(hex: "#ECE8F8")
    static let challengeSportBadge = Color(hex: "#E2F0DE")

    // Challenge completion
    static let challengeRadioInactive = Color(hex: "#C4D1D9")

}
