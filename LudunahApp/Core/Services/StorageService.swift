
import Foundation

// MARK: - Storage Service

/// Manages local persistence for onboarding, interests,
/// sport training plans, and activity completion history.
///
/// StorageService is the single place responsible for
/// reading and writing these values using UserDefaults.
final class StorageService {

    // MARK: - Dependencies

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Storage Keys

    private enum Keys {
        static let onboardingCompleted = "onboardingCompleted"
        static let selectedInterests = "selectedInterests"
        static let activityProgress = "activityProgress"
        static let sportCreatePlans = "sportCreatePlans"
    }

    // MARK: - Onboarding

    /// Persists the onboarding completion status.
    func saveOnboardingCompleted(_ completed: Bool) {
        defaults.set(completed, forKey: Keys.onboardingCompleted)
    }

    /// Returns whether the user has completed onboarding.
    func loadOnboardingCompleted() -> Bool {
        defaults.bool(forKey: Keys.onboardingCompleted)
    }

    // MARK: - Interests

    /// Persists the user's selected interests.
    func saveSelectedInterests(_ interests: Set<Interest>) {
        save(interests, forKey: Keys.selectedInterests)
    }

    /// Loads selected interests or returns an empty set.
    func loadSelectedInterests() -> Set<Interest> {
        load(Set<Interest>.self, forKey: Keys.selectedInterests) ?? []
    }

    // MARK: - Sport Training Plans

    /// Adds a training plan without removing existing plans.
    func saveSportCreatePlan(_ plan: SportCreateModel) {
        var plans = loadSportCreatePlans()
        plans.append(plan)

        save(plans, forKey: Keys.sportCreatePlans)
    }

    /// Loads all saved sport training plans.
    func loadSportCreatePlans() -> [SportCreateModel] {
        load([SportCreateModel].self, forKey: Keys.sportCreatePlans) ?? []
    }

    // MARK: - Activity Progress

    /// Records a new activity completion for the given interest.
    ///
    /// Every completion is stored as a separate record.
    func recordCompletedActivity(interest: Interest) {
        var progress = loadActivityProgress()
        progress.append(ActivityProgress(interest: interest))

        save(progress, forKey: Keys.activityProgress)
    }

    /// Loads the complete activity completion history.
    func loadActivityProgress() -> [ActivityProgress] {
        load([ActivityProgress].self, forKey: Keys.activityProgress) ?? []
    }

    /// Returns distinct interests completed on a given day.
    ///
    /// Multiple completions for the same interest count as one.
    func completedInterests(
        on date: Date = Date(),
        calendar: Calendar = .current
    ) -> Set<Interest> {
        let interests = loadActivityProgress()
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .map(\.interest)

        return Set(interests)
    }

    // MARK: - Weekly Progress

    /// Returns the number of activities completed on each
    /// of the last seven calendar days, oldest day first.
    ///
    /// Multiple completions on the same day are counted separately.
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

    /// Removes activity history without affecting other saved data.
    func resetProgress() {
        defaults.removeObject(forKey: Keys.activityProgress)
    }

    /// Clears all values managed by this service.
    func resetEverything() {
        defaults.removeObject(forKey: Keys.onboardingCompleted)
        defaults.removeObject(forKey: Keys.selectedInterests)
        defaults.removeObject(forKey: Keys.activityProgress)
        defaults.removeObject(forKey: Keys.sportCreatePlans)
    }

    // MARK: - Private Persistence Helpers

    /// Encodes and saves a Codable value.
    private func save<T: Encodable>(
        _ value: T,
        forKey key: String
    ) {
        guard let data = try? JSONEncoder().encode(value) else {
            return
        }

        defaults.set(data, forKey: key)
    }

    /// Loads and decodes a Codable value.
    private func load<T: Decodable>(
        _ type: T.Type,
        forKey key: String
    ) -> T? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }

        return try? JSONDecoder().decode(type, from: data)
    }
}
