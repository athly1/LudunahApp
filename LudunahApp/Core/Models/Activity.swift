import Foundation

struct Activity: Decodable, Identifiable {
    let id: String
    let type: ActivityStep
    let title: String

    // وصف مختصر ومهارات النشاط
    let summary: String?
    let skills: [String]?

    // بيانات التعلّم
    let layout: String?
    let howTo: [String]?
    let options: [ActivityOption]?
    let cards: [ActivityCard]?
    let insight: String?
    let sources: [String]?

    // بيانات التطبيق
    let durationMin: Int?
    let theme: String?
    let colors: [String]?
    let phases: [ActivityPhase]?

    // بيانات الابتكار
    let canvas: String?
    let materials: [String]?
    let question: String?

    // بيانات إضافية
    let needs: String?
    let safetyNote: String?
    let gain: ActivityGain?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title

        case summary = "description"
        case skills

        case layout
        case howTo = "how_to"
        case options
        case cards
        case insight
        case sources

        case durationMin = "duration_min"
        case theme
        case colors
        case phases

        case canvas
        case materials
        case question

        case needs
        case safetyNote = "safety_note"
        case gain
    }
}

struct ActivityOption: Decodable, Identifiable {
    let id: String
    let label: String
    let image: String?
    let text: String
}

struct ActivityCard: Decodable {
    let icon: String
    let text: String
}

struct ActivityPhase: Decodable {
    let durationSec: Int
    let text: String

    enum CodingKeys: String, CodingKey {
        case durationSec = "duration_sec"
        case text
    }
}

struct ActivityGain: Decodable {
    let title: String?
    let now: String
    let withPractice: String

    enum CodingKeys: String, CodingKey {
        case title
        case now
        case withPractice = "with_practice"
        case description
    }

    // يدعم الصيغتين:
    // - now / with_practice
    // - title / description (ملفات الفن الجديدة)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: .title)

        let nowValue = try container.decodeIfPresent(String.self, forKey: .now)
        let descriptionValue = try container.decodeIfPresent(String.self, forKey: .description)

        now = nowValue ?? descriptionValue ?? ""
        withPractice = try container.decodeIfPresent(String.self, forKey: .withPractice) ?? ""
    }
}
