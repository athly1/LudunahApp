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

enum AppRoute: Hashable {
    case activity(Interest)
    case settings
}

@Observable
final class AppRouter {

    var path = NavigationPath()
    private let storage = StorageService()
    // التحديات التي انتهى المستخدم منها
    private(set) var completedInterests: Set<Interest> = []

    // الانتقال إلى شاشة جديدة
    func push(_ route: AppRoute) {
        path.append(route)
    }

    // الرجوع إلى الشاشة السابقة
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    // يزيد كل ما انتهى المستخدم من نشاط (يستخدمه InstructionsSheet لإغلاق الشاشة)
    private(set) var finishedActivityCount = 0
    init() {
        refreshCompletedInterests()
    }

    /// Loads today's completed interests from local storage.
    func refreshCompletedInterests() {
        completedInterests = storage.completedInterests()
    }
    func popToRoot() {
        path = NavigationPath()
        finishedActivityCount += 1
    }

    // تسجيل الإنجاز عند الانتهاء فقط
    func markCompleted(_ interest: Interest) {
        completedInterests.insert(interest)
    }

    // إزالة الإنجاز إذا استُبدل التحدي
    func resetCompletion(_ interest: Interest) {
        completedInterests.remove(interest)
    }

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
