//
//  ActivityContent.swift
//  LudunahApp
//
//  Created by nuha on 26/10/2026.
//



import Foundation

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
