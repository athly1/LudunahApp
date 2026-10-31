
import SwiftUI

// MARK: - Onboarding View

// الشاشة الرئيسية لصفحات البداية.
// نستخدم ViewModel واحدًا لإدارة التنقل والاحتفاظ بالاهتمامات.
struct OnboardingView: View {

    // MARK: - State

    // يحتفظ بحالة الصفحات والاهتمامات أثناء التنقل.
    @State private var viewModel = OnboardingViewModel()

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            ZStack {

                // نعرض الصفحة الحالية حسب قيمة ViewModel.
                switch viewModel.currentPage {

                case 1:
                    // MARK: - Second Onboarding Screen

                    // صفحة مميزات التطبيق.
                    OnboardingBenefitsView(
                        onNext: { goTo(2) },
                        onSelectPage: goTo
                    )
                    .transition(
                        .slideToRight(width: proxy.size.width)
                    )

                case 2:
                    // MARK: - Third Onboarding Screen

                    // تمرير نفس ViewModel إلى صفحة الاهتمامات.
                    // هذا يحافظ على الاختيارات عند الرجوع بين الصفحات.
                    OnboardingInterestsView(
                        viewModel: viewModel,
                        onSelectPage: goTo
                    )
                    .transition(
                        .slideToRight(width: proxy.size.width)
                    )

                default:
                    // MARK: - First Onboarding Screen

                    GeometryReader { geometry in
                        VStack(spacing: 0) {

                            // MARK: - Page Indicator

                            HStack {
                                PageIndicator(
                                    currentPage: 0,
                                    onSelect: goTo
                                )

                                Spacer()
                            }
                            .padding(.top, 12)
                            .padding(.horizontal, 24)

                            Spacer()
                                .frame(
                                    height: geometry.size.height * 0.05
                                )

                            // MARK: - Illustration

                            // الرسومات التعريفية بالاهتمامات.
                            InterestIllustration()
                                .frame(
                                    height: geometry.size.height * 0.38
                                )
                                .padding(.horizontal, 24)

                            // MARK: - Text Content

                            VStack(
                                alignment: .leading,
                                spacing: 12
                            ) {
                                Text("دماغك ينمو كل يوم!")
                                    .font(
                                        .system(size: 32, weight: .bold)
                                    )
                                    .foregroundStyle(
                                        Color(
                                            red: 0.42,
                                            green: 0.30,
                                            blue: 0.17
                                        )
                                    )
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                    .multilineTextAlignment(.leading)

                                Text(
                                    "المرونة العصبية تعني أن دماغك يبني روابط جديدة مع كل شيء تتعلمه وتتدرب عليه، هذا التطبيق يساعدك على توجيه هذا التغيير."
                                )
                                .font(
                                    .system(size: 20, weight: .medium)
                                )
                                .foregroundStyle(
                                    Color(
                                        red: 0.42,
                                        green: 0.30,
                                        blue: 0.17
                                    )
                                )
                                .lineSpacing(3)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                                .multilineTextAlignment(.leading)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )
                            }
                            .frame(maxWidth: .infinity)
                            .environment(
                                \.layoutDirection,
                                .rightToLeft
                            )
                            .padding(.horizontal, 24)
                            .padding(.top, 28)

                            Spacer(minLength: 24)

                            // MARK: - Next Button

                            // الانتقال إلى صفحة المميزات.
                            PrimaryButton(title: "التالي") {
                                goTo(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                        }
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                        .background(
                            Color(
                                red: 0.96,
                                green: 0.95,
                                blue: 0.92
                            )
                        )
                    }
                    .transition(
                        .slideToRight(width: proxy.size.width)
                    )
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Navigation

    // الانتقال بين صفحات البداية باستخدام ViewModel.
    // نمنع الصفحات غير الموجودة ونحافظ على حركة الانتقال.
    private func goTo(_ page: Int) {
        guard (0...2).contains(page),
              page != viewModel.currentPage else {
            return
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            viewModel.goToPage(page)
        }
    }
}

// MARK: - Slide Transition

// حركة الانتقال الأفقية بين صفحات البداية.
// الإزاحة لا تنعكس تلقائيًا مع اتجاه RTL.
private struct HorizontalSlide: ViewModifier {

    let x: CGFloat

    func body(content: Content) -> some View {
        content.offset(x: x)
    }
}

private extension AnyTransition {

    // الشاشة الجديدة تدخل من اليسار،
    // والشاشة القديمة تخرج باتجاه اليمين.
    static func slideToRight(width: CGFloat) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: HorizontalSlide(x: -width),
                identity: HorizontalSlide(x: 0)
            ),
            removal: .modifier(
                active: HorizontalSlide(x: width),
                identity: HorizontalSlide(x: 0)
            )
        )
        .combined(with: .opacity)
    }
}

// MARK: - Interest Illustration

// الرسومات الثلاث الموجودة في الشاشة الأولى.
// نحافظ على تصميمها السابق بدون تغيير.
private struct InterestIllustration: View {

    var body: some View {
        GeometryReader { geometry in

            let cardWidth = (geometry.size.width - 64) / 3
            let cardHeight = geometry.size.height * 0.78

            HStack(spacing: 12) {

                ArtCard()
                    .frame(
                        width: cardWidth,
                        height: cardHeight
                    )

                PuzzleCard()
                    .frame(
                        width: cardWidth,
                        height: cardHeight
                    )

                MountainCard()
                    .frame(
                        width: cardWidth,
                        height: cardHeight
                    )
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .padding(.horizontal, 20)
            .background(Color.white.opacity(0.75))
            .clipShape(
                RoundedRectangle(cornerRadius: 48)
            )
            .shadow(
                color: .black.opacity(0.08),
                radius: 18,
                y: 8
            )
        }
    }
}

// MARK: - Art Card

// رسم مستوحى من التكوينات الهندسية للفن.
private struct ArtCard: View {

    var body: some View {
        GeometryReader { geometry in

            ZStack {

                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        Color(
                            red: 0.10,
                            green: 0.32,
                            blue: 0.25
                        )
                    )

                Rectangle()
                    .fill(
                        Color(
                            red: 0.85,
                            green: 0.61,
                            blue: 0.28
                        )
                    )
                    .frame(width: 4)
                    .offset(
                        x: geometry.size.width * 0.28
                    )

                VStack(spacing: 13) {

                    Rectangle()
                        .fill(
                            Color(
                                red: 0.65,
                                green: 0.78,
                                blue: 0.47
                            )
                        )
                        .frame(height: 3)

                    Rectangle()
                        .fill(.white)
                        .frame(height: 3)

                    Rectangle()
                        .fill(
                            Color(
                                red: 0.65,
                                green: 0.78,
                                blue: 0.47
                            )
                        )
                        .frame(height: 3)
                }
                .padding(.horizontal, 12)
                .offset(
                    y: geometry.size.height * 0.12
                )
            }
            .shadow(
                color: .black.opacity(0.16),
                radius: 5,
                y: 4
            )
        }
    }
}

// MARK: - Puzzle Card

// بطاقة الألعاب الإلكترونية.
// نرسم المربعات في مواقع محددة.
private struct PuzzleCard: View {

    var body: some View {
        GeometryReader { geometry in

            ZStack {

                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        Color(
                            red: 0.65,
                            green: 0.60,
                            blue: 0.88
                        )
                    )

                let positions: [(CGFloat, CGFloat, Color)] = [
                    (-0.25, -0.10, Color.cyan.opacity(0.65)),
                    (0.25, -0.10, Color.purple.opacity(0.65)),
                    (0, 0.10, .white),
                    (-0.25, 0.30, Color.purple.opacity(0.65)),
                    (0.25, 0.30, Color.cyan.opacity(0.65))
                ]

                ForEach(positions.indices, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 5)
                        .fill(positions[index].2)
                        .frame(width: 16, height: 16)
                        .position(
                            x: geometry.size.width
                                * (0.5 + positions[index].0),
                            y: geometry.size.height
                                * (0.5 + positions[index].1)
                        )
                }
            }
            .shadow(
                color: .black.opacity(0.16),
                radius: 5,
                y: 4
            )
        }
    }
}

// MARK: - Mountain Card

// بطاقة الرياضة التي تحتوي على رسم ثلاثة جبال.
private struct MountainCard: View {

    var body: some View {
        GeometryReader { geometry in

            ZStack {

                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        Color(
                            red: 0.96,
                            green: 0.88,
                            blue: 0.82
                        )
                    )

                HStack(alignment: .bottom, spacing: 8) {

                    Mountain()
                        .fill(
                            Color(
                                red: 0.57,
                                green: 0.23,
                                blue: 0.20
                            )
                        )

                    Mountain()
                        .fill(
                            Color(
                                red: 0.82,
                                green: 0.56,
                                blue: 0.43
                            )
                        )

                    Mountain()
                        .fill(
                            Color(
                                red: 0.36,
                                green: 0.52,
                                blue: 0.46
                            )
                        )
                }
                .frame(height: 22)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                .frame(
                    maxHeight: .infinity,
                    alignment: .bottom
                )
            }
            .shadow(
                color: .black.opacity(0.12),
                radius: 5,
                y: 4
            )
        }
    }
}

// MARK: - Mountain Shape

// رسم الجبل باستخدام مسار مثلث.
private struct Mountain: Shape {

    func path(in rect: CGRect) -> Path {
        Path { path in

            path.move(
                to: CGPoint(
                    x: rect.minX,
                    y: rect.maxY
                )
            )

            path.addLine(
                to: CGPoint(
                    x: rect.midX,
                    y: rect.minY
                )
            )

            path.addLine(
                to: CGPoint(
                    x: rect.maxX,
                    y: rect.maxY
                )
            )

            path.closeSubpath()
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView()
        .environment(AppState())
}
