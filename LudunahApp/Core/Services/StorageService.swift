
// StorageService.swift - التخزين المحلي والتقدم الأسبوعي.

import Foundation

final class StorageService {

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let onboardingCompleted = "onboardingCompleted"
        static let selectedInterests = "selectedInterests"
        static let activityProgress = "activityProgress"
        static let sportCreatePlans = "sportCreatePlans"
    }

    // MARK: - Onboarding

    func saveOnboardingCompleted(_ completed: Bool) {
        defaults.set(completed, forKey: Keys.onboardingCompleted)
    }

    func loadOnboardingCompleted() -> Bool {
        defaults.bool(forKey: Keys.onboardingCompleted)
    }

    // MARK: - Interests

    func saveSelectedInterests(_ interests: Set<Interest>) {
        guard let data = try? JSONEncoder().encode(interests) else {
            return
        }

        defaults.set(data, forKey: Keys.selectedInterests)
    }

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

    func saveSportCreatePlan(_ plan: SportCreateModel) {
        var plans = loadSportCreatePlans()
        plans.append(plan)

        guard let data = try? JSONEncoder().encode(plans) else {
            return
        }

        defaults.set(data, forKey: Keys.sportCreatePlans)
    }

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

    func recordCompletedActivity(interest: Interest) {
        var progress = loadActivityProgress()
        let newRecord = ActivityProgress(interest: interest)

        progress.append(newRecord)
        saveActivityProgress(progress)
    }

    private func saveActivityProgress(_ progress: [ActivityProgress]) {
        guard let data = try? JSONEncoder().encode(progress) else {
            return
        }

        defaults.set(data, forKey: Keys.activityProgress)
    }

    func loadActivityProgress() -> [ActivityProgress] {
        guard let data = defaults.data(forKey: Keys.activityProgress) else {
            return []
        }

        return (try? JSONDecoder().decode(
            [ActivityProgress].self,
            from: data
        )) ?? []
    }

    // MARK: - Weekly Progress

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

    func resetProgress() {
        defaults.removeObject(forKey: Keys.activityProgress)
    }

    func resetEverything() {
        defaults.removeObject(forKey: Keys.onboardingCompleted)
        defaults.removeObject(forKey: Keys.selectedInterests)
        defaults.removeObject(forKey: Keys.activityProgress)
        defaults.removeObject(forKey: Keys.sportCreatePlans)
    }
}
