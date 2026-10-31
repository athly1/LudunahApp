// AppRouter.swift - إدارة التنقل بين شاشات لُدُونه.
//
// Contains:
// - Routes for activities and settings.
// - NavigationPath for navigation history.
// - Push, pop, and popToRoot methods.
// - Temporary destination views.
//
// Used by: LudoonaApp, HomeView, TaskSheet.
// Learn: NavigationPath, enum, @Observable, @ViewBuilder.

import SwiftUI
import Observation

// MARK: - App Routes

enum AppRoute: Hashable {
    case activity(Interest)
    case settings
}

// MARK: - App Router

@Observable
final class AppRouter {

    // MARK: - Properties

    var path = NavigationPath()

    private let storage = StorageService()

    // اهتمامات المستخدم المكتملة اليوم
    private(set) var completedInterests: Set<Interest> = []

    // MARK: - Initialization

    init() {
        refreshCompletedInterests()
    }

    // MARK: - Navigation

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    // MARK: - Activity Completion

    // تحديث الإنجازات من التخزين المحلي
    func refreshCompletedInterests() {
        completedInterests = storage.completedInterests()
    }

    // تحديث حالة الإنجاز في الذاكرة فقط
    func markCompleted(_ interest: Interest) {
        completedInterests.insert(interest)
    }

    // إزالة حالة الإنجاز من الذاكرة فقط
    func resetCompletion(_ interest: Interest) {
        completedInterests.remove(interest)
    }

    // MARK: - Destinations

    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {

        case .activity(let interest):
            VStack(spacing: Spacing.space24) {
                Image(systemName: interest.iconName)
                    .font(.system(size: 50))

                Text("تحدي \(interest.title)")
                    .font(.title1Heading)

                Text("هذه شاشة مؤقتة لاختبار تسجيل الإنجاز.")
                    .font(.titleCards)
                    .multilineTextAlignment(.center)

                PrimaryButton(title: "إنهاء التحدي") {
                    self.markCompleted(interest)
                    self.pop()
                }
            }
            .padding(Spacing.pageMargin)
            .foregroundStyle(Color.textPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pageBackground.ignoresSafeArea())

        case .settings:
            SettingsView()
        }
    }
}
