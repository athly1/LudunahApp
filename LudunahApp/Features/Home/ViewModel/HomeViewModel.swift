
import Foundation
import Observation

// MARK: - Home ViewModel

/// Manages challenge selection based on the user's interests
/// and current energy level.
///
/// HomeView handles presentation, while this ViewModel
/// selects activities and manages challenge replacement.
@Observable
final class HomeViewModel {

    // MARK: - Energy

    /// User-selected energy value (0...100).
    var energyValue: Int = 50

    /// Energy category derived from the current value.
    var energyLevel: EnergyLevel {
        EnergyLevel.from(value: energyValue)
    }

    // MARK: - Challenge State

    /// Currently selected activity for each interest.
    private(set) var selectedActivities: [Interest: Activity] = [:]

    /// Latest error encountered while loading activities.
    private(set) var errorMessage: String?

    // MARK: - Challenge Loading

    /// Selects a random activity matching the current energy level
    /// for each selected interest.
    ///
    /// Existing selections are replaced whenever this method runs.
    func loadChallenges(for interests: Set<Interest>) {
        var newSelections: [Interest: Activity] = [:]
        errorMessage = nil

        for interest in interests {
            do {
                let matchingActivities = try ContentService
                    .loadActivities(for: interest)
                    .filter { $0.type == energyLevel.activityStep }

                if let activity = matchingActivities.randomElement() {
                    newSelections[interest] = activity
                }
            } catch {
                errorMessage = "تعذّر تحميل أنشطة \(interest.title)."
            }
        }

        selectedActivities = newSelections
    }

    // MARK: - Challenge Access

    /// Returns the selected activity for an interest.
    func activity(for interest: Interest) -> Activity? {
        selectedActivities[interest]
    }

    // MARK: - Challenge Replacement

    /// Replaces the current activity with a different activity
    /// from the same interest and energy category.
    ///
    /// Returns false if no alternative exists or loading fails.
    @discardableResult
    func swapChallenge(for interest: Interest) -> Bool {
        guard let currentActivity = selectedActivities[interest] else {
            return false
        }

        do {
            let alternatives = try ContentService
                .loadActivities(for: interest)
                .filter {
                    $0.type == energyLevel.activityStep &&
                    $0.id != currentActivity.id
                }

            guard let replacement = alternatives.randomElement() else {
                return false
            }

            selectedActivities[interest] = replacement
            errorMessage = nil
            return true

        } catch {
            errorMessage = "تعذّر تحميل أنشطة \(interest.title)."
            return false
        }
    }
}
