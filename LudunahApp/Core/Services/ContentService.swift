//
//  contenServices.swift
//  LudunahApp
//
//  Created by Athari Alotaibi on 10/05/1448 AH.
//


import Foundation

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

        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "json"
        ) else {
            throw ContentServiceError.fileNotFound(fileName)
        }

        let data = try Data(contentsOf: url)

        let content = try JSONDecoder().decode(
            ActivityContent.self,
            from: data
        )

        return content.activities
    }
}

enum ContentServiceError: Error {
    case fileNotFound(String)
}
