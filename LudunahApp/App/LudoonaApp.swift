import SwiftUI

@main
struct LudoonaApp: App {

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

private struct RootView: View {

    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var appRouter

    @State private var showSplash = true

    // تشخيص مؤقت
    private let debugStubHome = false

    var body: some View {
        @Bindable var router = appRouter

        // نقرأ الحالة هنا دائمًا (خارج if/else) حتى يسجّل SwiftUI المراقبة من أول رسم
        let isOnboardingCompleted = appState.isOnboardingCompleted
        let _ = print("RootView body: showSplash=\(showSplash), completed=\(isOnboardingCompleted)")

        Group {
            if showSplash {
                SplashView()
                    .task {
                        print("RootView: timer started")

                        do {
                            try await Task.sleep(for: .seconds(2))
                        } catch {
                            return
                        }

                        guard !Task.isCancelled else {
                            return
                        }

                        print("RootView: timer finished")

                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSplash = false
                        }
                    }

            } else if isOnboardingCompleted {
                NavigationStack(path: $router.path) {
                    // تشخيص: غيّر false إلى true لعرض شاشة بسيطة بدل HomeView
                    Group {
                        if debugStubHome {
                            Text("STUB HOME")
                                .onAppear { print("STUB HOME appeared") }
                        } else {
                            let _ = print("RootView: creating HomeView")
                            HomeView()
                        }
                    }
                        .navigationDestination(for: AppRoute.self) { route in
                            router.destination(for: route)
                        }
                }
                .onAppear {
                    print("RootView: HomeView appeared")
                }

            } else {
                OnboardingView()
                    .onAppear {
                        print("RootView: New OnboardingView appeared")
                    }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isOnboardingCompleted)
        .onChange(of: isOnboardingCompleted) { oldValue, newValue in
            print("Onboarding state changed: \(oldValue) -> \(newValue)")
        }
    }
}
