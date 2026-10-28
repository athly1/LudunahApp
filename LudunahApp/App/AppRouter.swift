// AppRouter.swift - إدارة التنقل بين شاشات لُدُونه.

import SwiftUI
import Observation

enum AppRoute: Hashable {
    case activity(Interest)
    case sportCreate(SportPlan)
    case settings
}

@Observable
final class AppRouter {
    var path = NavigationPath()

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else {
            return
        }

        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
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

                Text("قريبًا سنضيف شاشة التحدي")
                    .font(.titleCards)
            }
            .foregroundStyle(Color.textPrimary)

        case .sportCreate(let sport):
            SportCreateView(sport: sport)

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
