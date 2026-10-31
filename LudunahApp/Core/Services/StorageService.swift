
import Foundation

/// Manages local persistence for onboarding, interests,
/// sport training plans, and activity progress.
final class StorageService {

    // MARK: - Properties

    private let defaults = UserDefaults.standard

    // MARK: - Storage Keys

    private enum Keys {
        static let onboardingCompleted = "onboardingCompleted"
        static let selectedInterests = "selectedInterests"
        static let activityProgress = "activityProgress"
        static let sportCreatePlans = "sportCreatePlans"
    }

    // MARK: - Onboarding

    /// Saves the user's onboarding completion status.
    func saveOnboardingCompleted(_ completed: Bool) {
        defaults.set(completed, forKey: Keys.onboardingCompleted)
    }

    /// Returns whether onboarding has been completed.
    func loadOnboardingCompleted() -> Bool {
        defaults.bool(forKey: Keys.onboardingCompleted)
    }

    // MARK: - Interests

    /// Saves the user's selected interests.
    func saveSelectedInterests(_ interests: Set<Interest>) {
        guard let data = try? JSONEncoder().encode(interests) else {
            return
        }

        defaults.set(data, forKey: Keys.selectedInterests)
    }

    /// Loads the user's selected interests.
    func loadSelectedInterests() -> Set<Interest> {
        guard let data = defaults.data(forKey: Keys.selectedInterests) else {
            return []
        }

        return (try? JSONDecoder().decode(
            Set<Interest>.self,
            from: data
        )) ?? []
    }

    // MARK: - Sport Create Plans

    /// Saves a new sport training plan.
    func saveSportCreatePlan(_ plan: SportCreateModel) {
        var plans = loadSportCreatePlans()
        plans.append(plan)

        guard let data = try? JSONEncoder().encode(plans) else {
            return
        }

        defaults.set(data, forKey: Keys.sportCreatePlans)
    }

    /// Loads all saved sport training plans.
    func loadSportCreatePlans() -> [SportCreateModel] {
        guard let data = defaults.data(forKey: Keys.sportCreatePlans) else {
            return []
        }

        return (try? JSONDecoder().decode(
            [SportCreateModel].self,
            from: data
        )) ?? []
    }

    // MARK: - Activity Progress

    /// Records a completed activity for the given interest.
    func recordCompletedActivity(interest: Interest) {
        var progress = loadActivityProgress()

        let newRecord = ActivityProgress(interest: interest)
        progress.append(newRecord)

        saveActivityProgress(progress)
    }

    /// Persists the activity progress history.
    private func saveActivityProgress(_ progress: [ActivityProgress]) {
        guard let data = try? JSONEncoder().encode(progress) else {
            return
        }

        defaults.set(data, forKey: Keys.activityProgress)
    }

    /// Loads the complete activity progress history.
    func loadActivityProgress() -> [ActivityProgress] {
        guard let data = defaults.data(forKey: Keys.activityProgress) else {
            return []
        }

        return (try? JSONDecoder().decode(
            [ActivityProgress].self,
            from: data
        )) ?? []
    }

    /// Returns the interests completed on the specified day.
    ///
    /// Each interest appears only once, even if multiple
    /// activities were completed for that interest.
    ///
    /// - Parameters:
    ///   - date: The day to check. Defaults to today.
    ///   - calendar: Calendar used for day comparison.
    /// - Returns: A set of interests completed on that day.
    func completedInterests(
        on date: Date = Date(),
        calendar: Calendar = .current
    ) -> Set<Interest> {
        let progress = loadActivityProgress()

        let interests = progress
            .filter {
                calendar.isDate($0.date, inSameDayAs: date)
            }
            .map(\.interest)

        return Set(interests)
    }

    // MARK: - Weekly Progress

    /// Returns completed activity counts for the last seven days.
    /// The oldest day is first, and today is last.
    func weeklyCompletedCounts() -> [Int] {
        let calendar = Calendar.current
        let today = Date()
        let progress = loadActivityProgress()

        return (0..<7).map { index in
            let daysAgo = 6 - index

            guard let date = calendar.date(
                byAdding: .day,
                value: -daysAgo,
                to: today
            ) else {
                return 0
            }

            return progress.filter { record in
                calendar.isDate(record.date, inSameDayAs: date)
            }.count
        }
    }

    // MARK: - Reset

    /// Removes activity progress without affecting other data.
    func resetProgress() {
        defaults.removeObject(forKey: Keys.activityProgress)
    }

    /// Removes all data managed by StorageService.
    func resetEverything() {
        defaults.removeObject(forKey: Keys.onboardingCompleted)
        defaults.removeObject(forKey: Keys.selectedInterests)
        defaults.removeObject(forKey: Keys.activityProgress)
        defaults.removeObject(forKey: Keys.sportCreatePlans)
    }
}
