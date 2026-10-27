
// LudoonaApp.swift - نقطة تشغيل تطبيق لُدُونه.
//
// Contains:
// - The @main entry point.
// - Shared AppState and AppRouter.
// - OnboardingView or temporary Home.
// - NavigationStack and environment.
// - Arabic right-to-left layout.
//
// Used by: iOS system.
// Learn: @main, App, @State, WindowGroup.

import SwiftUI

// نقطة بداية التطبيق
@main
struct LudoonaApp: App {

    // حالة التطبيق
    @State private var appState = AppState()

    // مدير التنقل
    @State private var appRouter = AppRouter()

    // النافذة الرئيسية
    var body: some Scene {

        WindowGroup {

            Group {

                // إذا أكمل المستخدم البداية
                if appState.isOnboardingCompleted {

                    // نظام التنقل
                    
                    NavigationStack(path: $appRouter.path) {
                        HomeView()
                            .navigationDestination(for: AppRoute.self) { route in
                                appRouter.destination(for: route)
                            }
                    }


                } else {

                    // صفحات البداية الحقيقية
                    OnboardingView()
                }
            }

            // توفير حالة التطبيق
            .environment(appState)

            // توفير مدير التنقل
            .environment(appRouter)

            // الاتجاه العربي
            .environment(\.layoutDirection, .rightToLeft)

            // خلفية التطبيق
            .background(Color.pageBackground.ignoresSafeArea())
        }
    }
}
