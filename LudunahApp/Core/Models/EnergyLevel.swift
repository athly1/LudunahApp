// EnergyLevel.swift - enum: how much energy the user has today.
//
// Contains:
// - Enum cases (for example low, medium, high) with a String raw value.
// - Computed title, icon, and suggested minutes.
//
// Used by: EnergyCheckInView, HomeViewModel.



import Foundation

enum EnergyLevel: String, CaseIterable, Identifiable {
    case low
    case medium
    case high

    var id: String {
        rawValue
    }

    var activityStep: ActivityStep {
        switch self {
        case .low:
            return .learn

        case .medium:
            return .create

        case .high:
            return .doActivity
        }
    }

    static func from(value: Int) -> EnergyLevel {
        switch value {
        case 0...33:
            return .low

        case 34...66:
            return .medium

        default:
            return .high
        }
    }
}
