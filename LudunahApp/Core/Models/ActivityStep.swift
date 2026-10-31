// ActivityStep.swift - Defines the Learn, Do, and Create activity types.
//
// Used by: Activity, EnergyLevel, and activity-related views.


import Foundation

enum ActivityStep: String, CaseIterable, Identifiable, Codable, Hashable {

    case learn
    case doActivity = "do"
    case create

    var id: String {
        rawValue
    }

    var order: Int {
        switch self {
        case .learn:
            return 0
        case .doActivity:
            return 1
        case .create:
            return 2
        }
    }

    var title: String {
        switch self {
        case .learn:
            return "تعلّم"
        case .doActivity:
            return "طبّق"
        case .create:
            return "ابتكر"
        }
    }

    var next: ActivityStep? {
        switch self {
        case .learn:
            return .doActivity
        case .doActivity:
            return .create
        case .create:
            return nil
        }
    }

    var previous: ActivityStep? {
        switch self {
        case .learn:
            return nil
        case .doActivity:
            return .learn
        case .create:
            return .doActivity
        }
    }
}

