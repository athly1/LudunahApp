
// OnboardingView.swift - صفحات البداية لتطبيق لُدُونه.
//
// Contains:
// - Splash, Intro, How It Works, Interests.
// - InterestChip for interest selection.
// - PrimaryButton for navigation.
// - LudunahLogo from Assets.
// - Design System styling.
//
// Used by: LudoonaApp.
// Learn: TabView, @State, @Environment, Binding.

import SwiftUI

// MARK: - Onboarding View

struct OnboardingView: View {

    // منطق صفحات البداية
    @State private var viewModel = OnboardingViewModel()

    // حالة التطبيق المشتركة
    @Environment(AppState.self) private var appState

    // رقم الصفحة الأخيرة
    private let lastPage = 3

    var body: some View {

        VStack(spacing: Spacing.space24) {

            // عرض صفحات البداية
            TabView(
                selection: Binding(
                    get: {
                        viewModel.currentPage
                    },
                    set: { newPage in
                        viewModel.goToPage(newPage)
                    }
                )
            ) {

                // الصفحة الأولى
                splashPage
                    .tag(0)

                // الصفحة الثانية
                introPage
                    .tag(1)

                // الصفحة الثالثة
                howItWorksPage
                    .tag(2)

                // الصفحة الرابعة
                interestsPage
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            // زر التالي أو ابدأ
            PrimaryButton(
                title: viewModel.currentPage == lastPage
                    ? "ابدأ"
                    : "التالي",

                isDisabled: viewModel.currentPage == lastPage
                    && !viewModel.canFinish
            ) {

                // هل وصل المستخدم إلى آخر صفحة؟
                if viewModel.currentPage == lastPage {

                    // حفظ الاهتمامات وإنهاء البداية
                    viewModel.finish(using: appState)

                } else {

                    // الانتقال للصفحة التالية
                    viewModel.nextPage()
                }
            }
            .padding(.horizontal, Spacing.pageMargin)
            .padding(.bottom, Spacing.space16)
        }
        .background(Color.pageBackground.ignoresSafeArea())
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Splash

    private var splashPage: some View {

        VStack(spacing: Spacing.space24) {

            Spacer()

            // شعار لُدُونه من Assets
            Image("LudunahLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .accessibilityLabel("شعار لُدُونه")

            // اسم التطبيق
            Text("لُدُونه")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            // وصف التطبيق
            Text("مساحة صغيرة لتنشيط عقلك كل يوم")
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(Spacing.pageMargin)
    }

    // MARK: - Intro

    private var introPage: some View {

        VStack(spacing: Spacing.space24) {

            Spacer()

            Image(systemName: "sparkles")
                .font(.system(size: 70))
                .foregroundStyle(Color.appPrimary)

            Text("كل يوم فرصة تتعلم شيء جديد")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            Text("أنشطة ذهنية قصيرة مستوحاة من اهتماماتك، تجمع بين التعلم والتطبيق والإبداع.")
                .font(.titleCards)
                .foregroundStyle(Color.appSecondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(Spacing.pageMargin)
    }

    // MARK: - How It Works

    private var howItWorksPage: some View {

        VStack(spacing: Spacing.space24) {

            Spacer()

            Image(systemName: "lightbulb")
                .font(.system(size: 65))
                .foregroundStyle(Color.appPrimary)

            Text("كيف يعمل لُدُونه؟")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            // مراحل النشاط
            VStack(
                alignment: .leading,
                spacing: Spacing.space16
            ) {

                Label(
                    "تعلّم: اكتشف معلومة جديدة",
                    systemImage: "book"
                )

                Label(
                    "طبّق: جرّب نشاطًا قصيرًا",
                    systemImage: "hand.tap"
                )

                Label(
                    "ابتكر: عبّر عن أفكارك",
                    systemImage: "paintbrush"
                )
            }
            .font(.titleCards)
            .foregroundStyle(Color.textPrimary)

            Spacer()
        }
        .padding(Spacing.pageMargin)
    }

    // MARK: - Interests

    private var interestsPage: some View {

        VStack(spacing: Spacing.space24) {

            Spacer()

            Text("وش اهتماماتك؟")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            Text("اختاري المجالات اللي تحبينها عشان نخصص لك الأنشطة.")
                .font(.titleCards)
                .foregroundStyle(Color.appSecondary)
                .multilineTextAlignment(.center)

            // عرض الاهتمامات
            InterestChip(
                selectedInterests: viewModel.selectedInterests,
                onToggle: { interest in

                    // إضافة أو إزالة اهتمام
                    viewModel.toggleInterest(interest)
                }
            )

            // عدد الاهتمامات المختارة
            Text("اخترتِ \(viewModel.selectedInterests.count) من 3")
                .font(.dailyMinutesStyle)
                .foregroundStyle(Color.appSecondary)

            Spacer()
        }
        .padding(Spacing.pageMargin)
    }
}

// MARK: - Preview

#Preview {
    OnboardingView()
        .environment(AppState())
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}
