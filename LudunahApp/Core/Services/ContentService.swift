import Foundation

// Loads the JSON files content and decodes it into Model Objects
enum ContentService {

    static func loadActivities(for interest: Interest) throws -> [Activity] {

        let fileName: String

        switch interest {
        case .art:
            fileName = "Art"
        case .gaming:
            fileName = "Gaming"
        case .sport:
            fileName = "Sport"
        }

        //Finds JSON files in the app
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "json"
        ) else {
            throw ContentServiceError.fileNotFound(fileName)
        }

        //Read the files and store in data
        let data = try Data(contentsOf: url)

        //Converts the JSON into your ActivityContent model.
        let content = try JSONDecoder().decode(
            ActivityContent.self,
            from: data
        )

        //Array of Activity objects.
        return content.activities
    }
}

enum ContentServiceError: Error {
    case fileNotFound(String)
}

