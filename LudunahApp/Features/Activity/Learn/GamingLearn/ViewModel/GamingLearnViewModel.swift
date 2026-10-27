// @Observable class that loads today's GamingLearnModel.
import Foundation
import Combine

// the states needs to be maintiend an presist, so a Class and its able to be observed
final class GamingLearnViewModel: ObservableObject {
    
    // MONITORES THE VALUES CHANGES and broadcast it to any listing views
    @Published var index = 0
    @Published var cards: [ActivityCard] = []
    @Published var title = ""
 
    init() {
        do {
            // 1. Load all gaming activities from JSON.
            let activities = try ContentService.loadActivities(for: .gaming)

            // 2. Keep only learning activities.
            let learnActivities = activities.filter {
                $0.type == .learn
            }

            // 3. Randomly select one learning activity, Guard as it may return nil
            guard let randomActivity = learnActivities.randomElement() else {
                print("No learning activities found.")
                return
            }

            // 4. Populate the view model.
            title = randomActivity.title
            cards = randomActivity.cards ?? []

        } catch {
            print("Failed to load activities: \(error)")
        }
    }
  
    // computation or derived properties; don't need @Published. The underlying stored properties—cards and index—are published,
    
    // Derive the total from the array,
    var totalCards: Int { cards.count }
    
    // Adding 1 makes the first card show progress 1 / total.
    var currentProgress: Double { Double(index + 1) }
    
    // Checks whether the user is viewing the final card.
    var isLastCard: Bool { index == totalCards - 1 }

}
