
// ArtCreateModel.swift - بيانات أنشطة الإنشاء في الفن.
//
// Contains:
// - Grid drawing activity.
// - Color mixing rounds.
// - Activity instructions and questions.
// - Loading Create activities from Art.json.
//
// Used by: ArtCreateViewModel.
//
// Learn: Decodable, optional properties, JSONDecoder.

import Foundation

// MARK: - Color Mixing Round

struct ArtColorRound: Decodable {
    let colors: [String]
    let options: [String]
    let answer: String
    let resultColor: String
}

// MARK: - Art Create Model

struct ArtCreateModel: Identifiable {
    let id: String
    let title: String
    let description: String
    let canvas: String?
    let colors: [String]
    let rounds: [ArtColorRound]
    let howTo: [String]
    let question: String
    let sources: [String]
}

// MARK: - JSON Container

private struct ArtCreateContainer: Decodable {
    let activities: [ArtCreateEntry]
}

// MARK: - JSON Entry

private struct ArtCreateEntry: Decodable {
    let id: String
    let type: String
    let title: String
    let description: String?
    let canvas: String?
    let colors: [String]?
    let rounds: [ArtColorRound]?
    let howTo: [String]?
    let question: String?
    let sources: [String]?

    var createModel: ArtCreateModel? {

        guard type == "create" else {
            return nil
        }

        return ArtCreateModel(
            id: id,
            title: title,
            description: description ?? "",
            canvas: canvas,
            colors: colors ?? [],
            rounds: rounds ?? [],
            howTo: howTo ?? [],
            question: question ?? "",
            sources: sources ?? []
        )
    }
}

// MARK: - Loader

enum ArtCreateLoader {

    static func loadActivities() throws -> [ArtCreateModel] {

        guard let url = Bundle.main.url(
            forResource: "Art",
            withExtension: "json"
        ) else {
            throw CocoaError(.fileNoSuchFile)
        }

        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let container = try decoder.decode(
            ArtCreateContainer.self,
            from: data
        )

        return container.activities.compactMap {
            $0.createModel
        }
    }
}
