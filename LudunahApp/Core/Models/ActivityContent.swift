import Foundation

//Model of the top level JSON 
struct ActivityContent: Decodable {
    let interest: String
    let interestName: String
    let activities: [Activity]

    enum CodingKeys: String, CodingKey {
        case interest
        case interestName = "interest_name"
        case activities
    }
}

/// نشاط واحد. تختلف الحقول المتاحة حسب نوع النشاط (learn / do / create)،
/// لذلك الحقول الخاصة بكل نوع اختيارية.
struct Activity: Decodable, Identifiable {
    let id: String
    let type: String
    let title: String

    // محتوى التعلّم
    let cards: [ActivityCard]?
    let layout: String?
    let howTo: [String]?
    let options: [ActivityOption]?
    let insight: String?

    // محتوى التطبيق والإنشاء
    let needs: String?
    let durationMin: Int?
    let phases: [ActivityPhase]?
    let gain: ActivityGain?
    let safetyNote: String?
    let canvas: String?
    let materials: [String]?
    let question: String?
    let colors: [String]?
    let theme: String?

    let sources: [String]?

    enum CodingKeys: String, CodingKey {
        case id, type, title, cards, layout, options, insight, needs, phases
        case gain, canvas, materials, question, colors, theme, sources
        case howTo = "how_to"
        case durationMin = "duration_min"
        case safetyNote = "safety_note"
    }
}

struct ActivityCard: Decodable, Identifiable {
    let icon: String
    let text: String

    // يسمح باستخدام البطاقة مباشرةً داخل ForEach.
    var id: String { "\(icon)-\(text)" }
}

struct ActivityOption: Decodable, Identifiable {
    let id: String
    let label: String
    let image: String
    let text: String
}

struct ActivityPhase: Decodable, Identifiable {
    let durationSec: Int
    let text: String

    enum CodingKeys: String, CodingKey {
        case text
        case durationSec = "duration_sec"
    }

    var id: Int { durationSec }
}

struct ActivityGain: Decodable {
    let now: String
    let withPractice: String

    enum CodingKeys: String, CodingKey {
        case now
        case withPractice = "with_practice"
    }
}
