import Foundation

// 🔒 Team agreement: the only place that reads and writes persisted data.
final class StorageService {
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let interests = "selectedInterests"
        static let progress = "activityProgress"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: Onboarding

    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }

    // MARK: Interests

    func loadInterests() -> Set<Interest> {
        decode(Set<Interest>.self, forKey: Keys.interests) ?? []
    }

    func saveInterests(_ interests: Set<Interest>) {
        encode(interests, forKey: Keys.interests)
    }

    // MARK: Progress

    func loadProgress() -> [ActivityProgress] {
        decode([ActivityProgress].self, forKey: Keys.progress) ?? []
    }

    func recordCompletion(of interest: Interest, on date: Date = .now) {
        var progress = loadProgress()
        progress.append(ActivityProgress(date: date, interest: interest))
        encode(progress, forKey: Keys.progress)
    }

    /// Completed activity counts for the last 7 days, oldest first, ending on `date`.
    func weeklyProgress(endingOn date: Date = .now, calendar: Calendar = .current) -> [DailyProgress] {
        let progress = loadProgress()
        let today = calendar.startOfDay(for: date)

        return (0..<7).reversed().compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            let count = progress.filter { calendar.isDate($0.date, inSameDayAs: day) }.count
            return DailyProgress(date: day, completedCount: count)
        }
    }

    // MARK: Reset

    func resetProgress() {
        defaults.removeObject(forKey: Keys.progress)
    }

    func resetAll() {
        defaults.removeObject(forKey: Keys.hasCompletedOnboarding)
        defaults.removeObject(forKey: Keys.interests)
        defaults.removeObject(forKey: Keys.progress)
    }

    // MARK: Helpers

    private func decode<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    private func encode<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        defaults.set(data, forKey: key)
    }
}
