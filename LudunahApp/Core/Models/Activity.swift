//
//  Activity.swift
//  LudunahApp
//
//  Created by nuha on 26/10/2026.
//


import Foundation

//Object of the second level of JSON
struct Activity: Decodable, Identifiable {
    let id: String
    let type: ActivityStep
    let title: String

    let layout: String?
    let howTo: [String]?

    let options: [ActivityOption]?
    let cards: [ActivityCard]?

    let insight: String?
    let sources: [String]?

    let durationMin: Int?
    let theme: String?
    let colors: [String]?
    let phases: [ActivityPhase]?

    let canvas: String?
    let materials: [String]?
    let question: String?

    let needs: String?
    let safetyNote: String?
    let gain: ActivityGain?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
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

//Object of the 3rd level of JSON
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
    let now: String
    let withPractice: String

    enum CodingKeys: String, CodingKey {
        case now
        case withPractice = "with_practice"
    }
}
