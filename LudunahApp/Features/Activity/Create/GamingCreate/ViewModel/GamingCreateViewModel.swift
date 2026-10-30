import Foundation
import Combine

final class GamingCreateViewModel: ObservableObject {

    @Published var title = ""
    @Published var materials: [String] = []
    @Published var steps: [String] = []
    @Published var question = ""

    // activityID: النشاط المختار من الهوم. إذا لم يُرسل نختار عشوائيًا.
    init(activityID: String? = nil) {

        do {

            // Load gaming activities.
            let activities = try ContentService.loadActivities(for: .gaming)

            // Keep only Create activities.
            let createActivities = activities.filter {
                $0.type == .create
            }

            // Select a random activity.

            guard let activity =
                createActivities.first(where: { $0.id == activityID })
                ?? createActivities.randomElement() else {
                print("No Create activities found.")
                return
            }

            // Populate the properties.
            title = activity.title
            materials = activity.materials ?? []
            steps = activity.howTo ?? []
            question = activity.question ?? ""

        } catch {
            print("Failed to load activities: \(error)")
        }
    }
}
