
import SwiftUI
import Observation

// MARK: - Routes

/// Navigation destinations supported by the application.
enum AppRoute: Hashable {
    case settings
}

// MARK: - App Router

/// Manages navigation and provides the Home screen with
/// today's completed interests from persistent storage.
///
/// Activity screens are presented through InstructionsSheet,
/// not through navigation routes.
@Observable
final class AppRouter {

    // MARK: - Navigation

    var path = NavigationPath()

    // MARK: - Dependencies

    private let storage = StorageService()

    // MARK: - Completion State

    /// A cached set of interests completed today.
    private(set) var completedInterests: Set<Interest> = []

    // MARK: - Initialization

    init() {
        refreshCompletedInterests()
    }

    // MARK: - Navigation Actions

    /// Opens a destination using the shared navigation stack.
    func push(_ route: AppRoute) {
        path.append(route)
    }

    /// Returns to the previous destination, when available.
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    // MARK: - Activity Completion

    /// Reloads completed interests from StorageService.
    /// HomeView calls this after activity completion.
    func refreshCompletedInterests() {
        completedInterests = storage.completedInterests()
    }

    // MARK: - Destinations

    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {
        case .settings:
            SettingsView()
        }
    }
}
