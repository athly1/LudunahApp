import Foundation
import Combine

final class GamingDoViewModel: ObservableObject {

    @Published var title = ""
    @Published var needs = ""
    @Published var durationMin = 0
    @Published var steps: [String] = []

    init() {
        do {
            // Load gaming activities.
            let activities = try ContentService.loadActivities(for: .gaming)

            // Keep only Do activities.
            let doActivities = activities.filter {
                $0.type == .doActivity
            }

            // Select a random activity.
            guard let activity = doActivities.randomElement() else {
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
