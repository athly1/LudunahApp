import SwiftUI
import Observation

// MARK: - App Routes

/// Defines the destinations available in the navigation stack.
enum AppRoute: Hashable {
    case settings
}

// MARK: - App Router

/// Manages navigation between application screens.
///
/// Activity selection and progress are managed by HomeViewModel.
/// Activity completion data is persisted by StorageService.
@Observable
final class AppRouter {

    // MARK: - Navigation State

    var path = NavigationPath()

    // MARK: - Navigation Actions

    /// Opens a screen in the navigation stack.
    func push(_ route: AppRoute) {
        path.append(route)
    }

    /// Returns to the previous screen if possible.
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
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
