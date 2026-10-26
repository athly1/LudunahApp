// Interest.swift - enum: art, sport, gaming.
//
// Contains:
// - Enum with cases art, sport, gaming and a String raw value.
// - Conforms to CaseIterable, Identifiable, Codable, Hashable.
// - Computed title and icon name.
//
// Used by: onboarding, Home, Activity screens, AppState, StorageService.

// Interest.swift - تعريف الاهتمامات المتاحة للمستخدم.
//
// Contains:
// - Interest enum with supported interests.
// - Display title and icon for each interest.
//
// Used by: AppState, onboarding, Home, Activity screens.
// Learn: enum, CaseIterable, Identifiable, Codable, Hashable.
import Foundation
//String    يعطي كل اهتمام قيمة نصية، مثل "art"
//CaseIterable    يسمح لنا نعرض جميع الاهتمامات
//Identifiable    يعطي كل اهتمام هوية مميزة
//Codable    يساعدنا نحفظ الاهتمامات ونسترجعها
//Hashable    يسمح لنا نخزن الاهتمامات في Set بدون تكرار
enum Interest: String, CaseIterable, Identifiable, Codable, Hashable {
    case art
    case sport
    case gaming
    
    var id: String { rawValue }
    // اسم الاهتمام الذي يظهر للمستخدم بالعربي
    var title: String {
        switch self {
        case .art:
            return " الفن السعودي"
        case .sport:
            return "الرياضة"
        case .gaming:
            return " الألعاب الالكترونية"
        }
    }
    
    // اسم الأيقونة المستخدمة من SF Symbols
    var iconName: String {
        switch self {
        case .art:
            return "paintpalette"
        case .sport:
            return "figure.run"
        case .gaming:
            return "gamecontroller"
        }
    }}
