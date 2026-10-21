import SwiftUI

@main
struct LudoonaApp: App {
    @State private var appState = AppState()
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(router)
        }
    }
}

/// Shows onboarding until it is completed, then the main navigation stack.
private struct RootView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        Group {
            if appState.hasCompletedOnboarding {
                NavigationStack(path: $router.path) {
                    HomeView()
                        .navigationDestination(for: Route.self) { route in
                            router.destination(for: route)
                        }
                }
            } else {
                OnboardingView()
            }
        }
        .tint(Theme.Colors.primary)
        .animation(.default, value: appState.hasCompletedOnboarding)
        .onChange(of: appState.hasCompletedOnboarding) {
            router.popToRoot()
        }
    }
}
