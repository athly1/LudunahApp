import Foundation
import Observation

/// App-wide state shared through the environment.
/// Views read from it; changes are persisted through `StorageService`.
@Observable
final class AppState {
    private let storage: StorageService

    private(set) var hasCompletedOnboarding: Bool
    private(set) var selectedInterests: Set<Interest>
    private(set) var weeklyProgress: [DailyProgress]
    var energyLevel: EnergyLevel?

    init(storage: StorageService = StorageService()) {
        self.storage = storage
        self.hasCompletedOnboarding = storage.hasCompletedOnboarding
        self.selectedInterests = storage.loadInterests()
        self.weeklyProgress = storage.weeklyProgress()
    }

    /// Interests in a stable display order.
    var orderedInterests: [Interest] {
        Interest.allCases.filter(selectedInterests.contains)
    }

    func completeOnboarding(with interests: Set<Interest>) {
        updateInterests(interests)
        storage.hasCompletedOnboarding = true
        hasCompletedOnboarding = true
    }

    func updateInterests(_ interests: Set<Interest>) {
        selectedInterests = interests
        storage.saveInterests(interests)
    }

    func recordCompletion(of interest: Interest) {
        storage.recordCompletion(of: interest)
        weeklyProgress = storage.weeklyProgress()
    }

    func resetProgress() {
        storage.resetProgress()
        weeklyProgress = storage.weeklyProgress()
    }

    /// Clears everything and sends the user back to onboarding.
    func resetAll() {
        storage.resetAll()
        hasCompletedOnboarding = false
        selectedInterests = []
        energyLevel = nil
        weeklyProgress = storage.weeklyProgress()
    }
}
