
// AppRouter.swift - إدارة التنقل بين شاشات التطبيق.
//
// Contains:
// - A Hashable enum representing app destinations.
// - An @Observable class holding NavigationPath.
// - Methods to push, pop, and return to root.
// - A destination mapping for activity and settings.
//
// Used by: LudoonaApp, HomeView, TaskSheet, ActivityFlowView.
// Learn: enum, associated values, NavigationPath,
//       NavigationStack, navigationDestination.

import SwiftUI // يوفر واجهات SwiftUI وأدوات التنقل
import Observation // يوفر @Observable

// MARK: - App Routes

// تعريف الشاشات التي يمكن الانتقال إليها
enum AppRoute: Hashable {

    // شاشة نشاط مرتبط باهتمام معين
    case activity(Interest)

    // شاشة الإعدادات
    case settings
}

// MARK: - App Router

// يجعل SwiftUI تتابع تغييرات التنقل
@Observable
final class AppRouter {

    // يحتفظ بمسار الشاشات المفتوحة
    var path = NavigationPath()

    // MARK: - Push

    // الانتقال إلى شاشة جديدة
    func push(_ route: AppRoute) {

        // إضافة الوجهة الجديدة لمسار التنقل
        path.append(route)
    }

    // MARK: - Pop

    // الرجوع إلى الشاشة السابقة
    func pop() {

        // نتأكد أن فيه شاشة يمكن الرجوع منها
        guard !path.isEmpty else {
            return
        }

        // حذف آخر شاشة من المسار
        path.removeLast()
    }

    // MARK: - Pop to Root

    // الرجوع إلى الصفحة الرئيسية
    func popToRoot() {

        // إزالة جميع الشاشات من مسار التنقل
        path = NavigationPath()
    }

    
    // MARK: - Destination Mapping

    // تحديد الشاشة المناسبة لكل وجهة
    @ViewBuilder
    func destination(for route: AppRoute) -> some View {

        // نحدد الشاشة المطلوبة حسب نوع الوجهة
        switch route {

        // إذا اختار المستخدم أحد الأنشطة
        case .activity(let interest):

            // شاشة مؤقتة إلى أن نبني ActivityFlowView
            VStack(spacing: 20) {

                Image(systemName: interest.iconName)
                    .font(.system(size: 50))

                Text("تحدي \(interest.title)")
                    .font(.title)

                Text("قريبًا سنضيف شاشة التحدي")
                    .foregroundStyle(.secondary)
            }

        // إذا اختار المستخدم الإعدادات
        case .settings:

            // شاشة مؤقتة إلى أن نبني SettingsView
            VStack(spacing: 20) {

                Image(systemName: "gearshape")
                    .font(.system(size: 50))

                Text("الإعدادات")
                    .font(.title)

                Text("قريبًا سنضيف إعدادات التطبيق")
                    .foregroundStyle(.secondary)
            }
        }
    }}

