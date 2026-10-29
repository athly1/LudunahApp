import Foundation

enum SportPlan: String, CaseIterable, Identifiable, Hashable, Codable {
    case football
    case padel

    var id: String { rawValue }

    var subtitle: String {
        switch self {
        case .football:
            "حدّد نوع ومستوى ومدة تمرين كرة القدم، وسمّ خطتك عشان ترجع لها وقت التدريب."
        case .padel:
            "حدّد نوع ومستوى ومدة تمرين البادل، وسمّ خطتك عشان ترجع لها وقت التدريب."
        }
    }

    var exerciseTypes: [SportExerciseType] {
        switch self {
        case .football:
            [.attacking, .defensive, .fitness]
        case .padel:
            [.serve, .rally, .movement]
        }
    }

    var defaultExerciseType: SportExerciseType {
        switch self {
        case .football: .defensive
        case .padel: .rally
        }
    }
}

enum SportExerciseType: String, CaseIterable, Identifiable, Codable {
    case attacking
    case defensive
    case fitness
    case serve
    case rally
    case movement

    var id: String { rawValue }

    var title: String {
        switch self {
        case .attacking: "هجومي"
        case .defensive: "دفاعي"
        case .fitness: "بدني"
        case .serve: "إرسال"
        case .rally: "تبادل الكرات"
        case .movement: "حركة"
        }
    }
}

enum SportDifficulty: String, CaseIterable, Identifiable, Codable {
    case easy
    case medium
    case hard

    var id: String { rawValue }

    var title: String {
        switch self {
        case .easy: "سهل"
        case .medium: "متوسط"
        case .hard: "صعب"
        }
    }
}

enum SportSpace: String, CaseIterable, Identifiable, Codable {
    case small
    case medium
    case large

    var id: String { rawValue }

    var title: String {
        switch self {
        case .small: "صغيرة"
        case .medium: "متوسطة"
        case .large: "كبيرة"
        }
    }
}
