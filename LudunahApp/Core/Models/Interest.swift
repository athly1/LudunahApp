
// Interest.swift - تعريف اهتمامات المستخدم.
//
// Contains:
// - Enum for art, sport, gaming.
// - Arabic titles and SF Symbol names.
//
// Used by: AppState, Onboarding, Home, Activities.
// Learn: enum, CaseIterable, Codable, Hashable.

import Foundation

// أنواع الاهتمامات المتاحة
enum Interest: String, CaseIterable, Identifiable, Codable, Hashable {

    case art      // الفن
    case sport    // الرياضة
    case gaming   // القايمنق

    // معرف كل اهتمام
    var id: String {
        rawValue
    }

    // الاسم الذي يظهر للمستخدم
    var title: String {
        switch self {
        case .art:
            return "الفن السعودي"
        case .sport:
            return "الرياضة"
        case .gaming:
            return "القايمنق"
        }
    }

    // أيقونة الاهتمام من SF Symbols
    var iconName: String {
        switch self {
        case .art:
            return "paintpalette"
        case .sport:
            return "figure.run"
        case .gaming:
            return "gamecontroller"
        }
    }
}
