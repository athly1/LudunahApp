
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

