
import SwiftUI

// MARK: - App Entry Point

@main
struct LudoonaApp: App {

    // MARK: - Shared State

    @State private var appState = AppState()
    @State private var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(appRouter)
                .environment(\.layoutDirection, .rightToLeft)
                .background(Color.pageBackground.ignoresSafeArea())
        }
    }
}

// MARK: - Root View

private struct RootView: View {

    // MARK: - Environment

    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var appRouter

    // MARK: - State

    @State private var showSplash = true

    // MARK: - Body

    var body: some View {
        @Bindable var router = appRouter

        let isOnboardingCompleted = appState.isOnboardingCompleted

        Group {
            if showSplash {
                SplashView()
                    .task {
                        await finishSplash()
                    }

            } else if isOnboardingCompleted {
                NavigationStack(path: $router.path) {
                    HomeView()
                        .navigationDestination(for: AppRoute.self) { route in
                            router.destination(for: route)
                        }
                }

            } else {
                OnboardingView()
            }
        }
        .animation(
            .easeInOut(duration: 0.3),
            value: isOnboardingCompleted
        )
    }

    // MARK: - Splash

    private func finishSplash() async {
        do {
            try await Task.sleep(for: .seconds(2))
        } catch {
            return
        }

        guard !Task.isCancelled else {
            return
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            showSplash = false
        }
    }
}
