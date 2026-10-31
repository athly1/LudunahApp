
import Foundation
import Observation

// MARK: - Home ViewModel

/// Manages the Home screen's challenges and progress.
///
/// Responsibilities:
/// - Select challenges based on the user's energy level.
/// - Provide the currently selected activity for each interest.
/// - Replace challenges with suitable alternatives.
/// - Load daily and weekly activity progress.
///
/// HomeView handles presentation and user interactions.
/// StorageService handles persistent data.
@Observable
final class HomeViewModel {

    // MARK: - Energy

    /// User-selected energy value (0...100).
    var energyValue: Int = 50

    /// Energy category derived from the selected value.
    var energyLevel: EnergyLevel {
        EnergyLevel.from(value: energyValue)
    }

    // MARK: - Challenge State

    /// Currently selected activity for each interest.
    private(set) var selectedActivities: [Interest: Activity] = [:]

    /// Latest error encountered when loading activities.
    private(set) var errorMessage: String?

    // MARK: - Progress State

    /// Distinct interests completed today.
    ///
    /// Completing multiple activities for the same interest
    /// still marks that interest as completed only once.
    private(set) var completedInterests: Set<Interest> = []

    /// Number of activities completed on each of the last
    /// seven days, ordered from oldest day to today.
    private(set) var weeklyCounts: [Int] = []

    // MARK: - Dependencies

    /// Handles reading saved activity progress.
    private let storage = StorageService()

    // MARK: - Challenge Loading

    /// Selects a random activity for every selected interest,
    /// matching the current energy level.
    ///
    /// Reloading challenges replaces the previous selections.
    func loadChallenges(for interests: Set<Interest>) {
        var newSelections: [Interest: Activity] = [:]

        errorMessage = nil

        for interest in interests {
            do {
                let matchingActivities = try ContentService
                    .loadActivities(for: interest)
                    .filter {
                        $0.type == energyLevel.activityStep
                    }

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

    /// Returns the currently selected activity for an interest.
    func activity(for interest: Interest) -> Activity? {
        selectedActivities[interest]
    }

    // MARK: - Challenge Replacement

    /// Replaces the current activity with another activity
    /// from the same interest and energy category.
    ///
    /// Returns false if there is no alternative or loading fails.
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

    // MARK: - Activity Progress

    /// Refreshes daily completion indicators and the weekly chart
    /// using the activity records saved in StorageService.
    ///
    /// Call this when:
    /// - Home first appears.
    /// - The app becomes active.
    /// - The instructions sheet closes after an activity.
    func refreshProgress() {
        completedInterests = storage.completedInterests()
        weeklyCounts = storage.weeklyCompletedCounts()
    }
}
