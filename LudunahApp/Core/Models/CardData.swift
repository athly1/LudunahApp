import Foundation

//One card's content (matches one item in the JSON)
struct CardData: Decodable {
    let icon: String
    let text: String
}

//The whole JSON file: { "cards": [ ... ] }
struct Lesson: Decodable {
    let cards: [CardData]
}

import SwiftUI

//Icon key from JSON → SF Symbol + background + icon color
typealias IconStyle = (symbol: String, background: Color, color: Color)

let iconStyles: [String: IconStyle] = [
    "hook":     ("map",                 Color(hex: "FFF1DC"), Color(hex: "C9822B")),
    "brain":    ("brain.head.profile",  Color(hex: "F3E6F5"), Color(hex: "8E3B9C")),
    "study":    ("magnifyingglass",     Color(hex: "E3F5EA"), Color(hex: "2E8B57")),
    "question": ("questionmark.circle", Color(hex: "E3F2F5"), Color(hex: "4A3B8C"))
]

//Used when the icon key isn't in the list above
let defaultStyle: IconStyle = ("circle", Color(hex: "EEEEEE"), .gray)
