import Foundation
import Combine

final class GamingDoViewModel: ObservableObject {

    @Published var title = ""
    @Published var needs = ""
    @Published var durationMin = 0
    @Published var steps: [String] = []

    // activityID: النشاط المختار من الهوم. إذا لم يُرسل نختار عشوائيًا.
    init(activityID: String? = nil) {
        do {
            // Load gaming activities.
            let activities = try ContentService.loadActivities(for: .gaming)

            // Keep only Do activities.
            let doActivities = activities.filter {
                $0.type == .doActivity
            }

            // Select a random activity.
            guard let activity =
                doActivities.first(where: { $0.id == activityID })
                ?? doActivities.randomElement() else {
                print("No Do activities found.")
                return
            }

            // Populate the properties.
            title = activity.title
            needs = activity.needs ?? ""
            durationMin = activity.durationMin ?? 0
            steps = activity.howTo ?? []

        } catch {
            print("Failed to load activities: \(error)")
        }
    }
}
