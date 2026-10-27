// ActivityStep.swift - enum: learn, do, create.
//
// Contains:
// - Enum with cases learn, do, create and an Int raw value for order.
// - Computed title, next step, previous step.
// - Note: "do" is a Swift keyword. Use backticks or another name.
//
// Used by: ActivityFlowView, ActivityHeader.



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
