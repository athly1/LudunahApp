
import SwiftUI

struct OnboardingView: View {

    // MARK: - Navigation State

    // 0 = الشاشة الأولى، 1 = المميزات، 2 = الاهتمامات
    @State private var step = 0

    var body: some View {

        GeometryReader { proxy in

        ZStack {

            switch step {

            case 1:

                // Second Onboarding Screen

                OnboardingBenefitsView(
                    onNext: { goTo(2) },
                    onSelectPage: goTo
                )
                .transition(.slideToRight(width: proxy.size.width))

            case 2:

                // Third Onboarding Screen

                OnboardingInterestsView(onSelectPage: goTo)
                    .transition(.slideToRight(width: proxy.size.width))

            default:

                // First Onboarding Screen

                GeometryReader { geometry in

                    VStack(spacing: 0) {

                        // MARK: - Page Indicator

                        // في RTL أول عنصر يكون على اليمين، لذلك النقاط قبل الـ Spacer
                        HStack {

                            PageIndicator(currentPage: 0, onSelect: goTo)

                            Spacer()
                        }
                        .padding(.top, 12)
                        .padding(.horizontal, 24)

                        Spacer()
                            .frame(height: geometry.size.height * 0.05)

                        // MARK: - Illustration

                        InterestIllustration()
                            .frame(
                                height: geometry.size.height * 0.38
                            )
                            .padding(.horizontal, 24)

                        // MARK: - Text Content

                        VStack(alignment: .leading, spacing: 12) {

                            Text("دماغك ينمو كل يوم!")
                                .font(.system(size: 32, weight: .bold))
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
                            .font(.system(size: 20, weight: .medium))
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
                        .environment(\.layoutDirection, .rightToLeft)
                        .padding(.horizontal, 24)
                        .padding(.top, 28)

                        Spacer(minLength: 24)

                  
                        // MARK: - Next Button

                        PrimaryButton(title: "التالي") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                goTo(1)
                            }
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
                        .transition(.slideToRight(width: proxy.size.width))
            }
        }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    // الانتقال لصفحة معيّنة (من الأزرار أو من نقاط الصفحات)
    private func goTo(_ page: Int) {
        guard page != step else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            step = page
        }
    }
}

// MARK: - Slide Transition

// يحرك الشاشة أفقيًا بعدد نقاط ثابت.
// offset لا ينعكس مع RTL، لذلك اتجاه الحركة ثابت دائمًا.
private struct HorizontalSlide: ViewModifier {

    let x: CGFloat

    func body(content: Content) -> some View {
        content.offset(x: x)
    }
}

private extension AnyTransition {

    // الشاشة الجديدة تدخل من اليسار والقديمة تخرج لليمين
    // (كل شيء يتحرك باتجاه اليمين).
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

private struct InterestIllustration: View {

    var body: some View {

        GeometryReader { geometry in

            let cardWidth = (geometry.size.width - 64) / 3
            let cardHeight = geometry.size.height * 0.78

            HStack(spacing: 12) {

                ArtCard()
                    .frame(width: cardWidth, height: cardHeight)

                PuzzleCard()
                    .frame(width: cardWidth, height: cardHeight)

                MountainCard()
                    .frame(width: cardWidth, height: cardHeight)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
            .background(Color.white.opacity(0.75))
            .clipShape(RoundedRectangle(cornerRadius: 48))
            .shadow(
                color: .black.opacity(0.08),
                radius: 18,
                y: 8
            )
        }
    }
}

// MARK: - Art Card

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
                    .offset(x: geometry.size.width * 0.28)

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
                .offset(y: geometry.size.height * 0.12)
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

