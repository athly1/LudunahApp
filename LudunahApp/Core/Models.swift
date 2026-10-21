import Foundation

// 🔒 Team agreement: shared data types used by every feature.
// Change these only after agreeing with the whole team.

// MARK: - Interest

enum Interest: String, CaseIterable, Identifiable, Codable, Hashable {
    case gaming
    case sport
    case art

    var id: String { rawValue }

    var title: String {
        switch self {
        case .gaming: String(localized: "Gaming")
        case .sport: String(localized: "Sport")
        case .art: String(localized: "Art")
        }
    }

    var symbol: String {
        switch self {
        case .gaming: "gamecontroller.fill"
        case .sport: "figure.run"
        case .art: "paintpalette.fill"
        }
    }
}

// MARK: - ActivityStep

/// Every activity follows the same Learn → Do → Create flow.
enum ActivityStep: Int, CaseIterable, Identifiable, Codable, Hashable {
    case learn
    case practice
    case create

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .learn: String(localized: "Learn")
        case .practice: String(localized: "Do")
        case .create: String(localized: "Create")
        }
    }

    var summary: String {
        switch self {
        case .learn: String(localized: "Discover something new about your interest.")
        case .practice: String(localized: "Try it out with a short, hands-on challenge.")
        case .create: String(localized: "Make something that is yours.")
        }
    }

    var symbol: String {
        switch self {
        case .learn: "book.fill"
        case .practice: "hand.tap.fill"
        case .create: "sparkles"
        }
    }

    /// The step that follows this one, or `nil` when the flow is finished.
    var next: ActivityStep? { ActivityStep(rawValue: rawValue + 1) }

    /// The step before this one, or `nil` on the first step.
    var previous: ActivityStep? { ActivityStep(rawValue: rawValue - 1) }
}

// MARK: - EnergyLevel

enum EnergyLevel: String, CaseIterable, Identifiable, Codable, Hashable {
    case low
    case medium
    case high

    var id: String { rawValue }

    var title: String {
        switch self {
        case .low: String(localized: "Low")
        case .medium: String(localized: "Okay")
        case .high: String(localized: "Great")
        }
    }

    var symbol: String {
        switch self {
        case .low: "battery.25percent"
        case .medium: "battery.50percent"
        case .high: "battery.100percent"
        }
    }

    /// Suggested activity length for this energy level.
    var suggestedMinutes: Int {
        switch self {
        case .low: 5
        case .medium: 10
        case .high: 20
        }
    }
}

// MARK: - DailyTask

struct DailyTask: Identifiable, Codable, Hashable {
    var id = UUID()
    let interest: Interest
    let title: String
    let detail: String
    let minutes: Int
}

// MARK: - Progress

/// One completed activity session.
struct ActivityProgress: Codable, Hashable {
    let date: Date
    let interest: Interest
}

/// Number of completed activities on a single day, used by the weekly chart.
struct DailyProgress: Identifiable, Hashable {
    let date: Date
    let completedCount: Int

    var id: Date { date }
}
