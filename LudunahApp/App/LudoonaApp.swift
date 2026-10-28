
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

    // هل شاشة البداية (Splash) ما زالت ظاهرة؟
    @State private var showSplash = true

    // النافذة الرئيسية
    var body: some Scene {

        WindowGroup {

            Group {

                // شاشة الـ Splash تظهر ثانيتين عند كل فتح للتطبيق
                if showSplash {

                    SplashView {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showSplash = false
                        }
                    }

                // إذا أكمل المستخدم البداية
                } else if appState.isOnboardingCompleted {

                    // نظام التنقل
                    NavigationStack(path: $appRouter.path) {

                        // Home مؤقتة
                        VStack(spacing: Spacing.space24) {

                            // عنوان الصفحة
                            Text("أهلًا بك في لُدُونه")
                                .font(.title1Heading)
                                .foregroundStyle(Color.textPrimary)

                            // وصف الصفحة
                            Text("اختر التحدي اللي يناسبك")
                                .font(.titleCards)
                                .foregroundStyle(Color.appSecondary)

                            // نشاط الفن
                            Button("تحدي الفن") {
                                appRouter.push(.activity(.art))
                            }

                            // الإعدادات
                            Button("الإعدادات") {
                                appRouter.push(.settings)
                            }

                            // إعادة صفحات البداية
                            Button("إعادة البداية") {

                                // العودة للمسار الأساسي
                                appRouter.popToRoot()

                                // مسح حالة البداية والاهتمامات
                                appState.reset()
                            }
                        }

                        // ربط الوجهات بالشاشات
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
