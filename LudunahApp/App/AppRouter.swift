
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

// تعريف وجهات التنقل
enum AppRoute: Hashable {

    // نشاط مرتبط باهتمام
    case activity(Interest)

    // صفحة الإعدادات
    case settings
}

// مدير التنقل
@Observable
final class AppRouter {

    // مسار الشاشات المفتوحة
    var path = NavigationPath()

    // الانتقال إلى شاشة جديدة
    func push(_ route: AppRoute) {

        // إضافة الوجهة الجديدة لمسار التنقل
        path.append(route)
    }

    // MARK: - Pop

    // الرجوع إلى الشاشة السابقة
    func pop() {

        // لا نحذف من مسار فارغ
        guard !path.isEmpty else {
            return
        }

        // حذف آخر وجهة
        path.removeLast()
    }

    // الرجوع للشاشة الأساسية
    func popToRoot() {
        path = NavigationPath()
    }

    // تحديد الواجهة المناسبة
    @ViewBuilder
    func destination(for route: AppRoute) -> some View {

        switch route {

        // شاشة نشاط مؤقتة
        case .activity(let interest):

            VStack(spacing: Spacing.space24) {

                Image(systemName: interest.iconName)
                    .font(.system(size: 50))

                Text("تحدي \(interest.title)")
                    .font(.title1Heading)

                Text("قريبًا سنضيف شاشة التحدي")
                    .font(.titleCards)
            }
            .foregroundStyle(Color.textPrimary)

        // شاشة إعدادات مؤقتة
        case .settings:

            VStack(spacing: Spacing.space24) {

                Image(systemName: "gearshape")
                    .font(.system(size: 50))

                Text("الإعدادات")
                    .font(.title1Heading)

                Text("قريبًا سنضيف إعدادات التطبيق")
                    .font(.titleCards)
            }
            .foregroundStyle(Color.textPrimary)
        }
    }
}
