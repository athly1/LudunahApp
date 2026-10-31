
import Foundation
import Observation

// MARK: - App State

/// Holds application-wide onboarding and interest preferences.
///
/// Persistent values are loaded from StorageService at startup.
/// Views observe this state through SwiftUI's environment.
@Observable
final class AppState {

    // MARK: - State

    /// Whether the user has completed onboarding.
    private(set) var isOnboardingCompleted: Bool

    /// The user's selected interests.
    private(set) var selectedInterests: Set<Interest>

    // MARK: - Dependencies

    private let storage: StorageService

    // MARK: - Initialization

    /// Restores saved application state at startup.
    init(storage: StorageService = StorageService()) {
        self.storage = storage
        self.isOnboardingCompleted = storage.loadOnboardingCompleted()
        self.selectedInterests = storage.loadSelectedInterests()
    }

    // MARK: - Onboarding

    /// Marks onboarding as completed and persists the result.
    func completeOnboarding() {
        isOnboardingCompleted = true
        storage.saveOnboardingCompleted(true)
    }

    // MARK: - Interests

    /// Updates and persists the user's selected interests.
    func updateInterests(_ interests: Set<Interest>) {
        selectedInterests = interests
        storage.saveSelectedInterests(interests)
    }

    // MARK: - Reset

    /// Clears saved application data and resets the in-memory state.
    func reset() {
        storage.resetEverything()
        isOnboardingCompleted = false
        selectedInterests = []
    }
}
