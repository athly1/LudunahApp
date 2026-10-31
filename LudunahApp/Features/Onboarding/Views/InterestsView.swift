
import SwiftUI

// MARK: - Main View

// شاشة اختيار اهتمامات المستخدم أثناء Onboarding.
// تستقبل ViewModel نفسه المستخدم في OnboardingView
// حتى لا تضيع الاختيارات عند التنقل بين الصفحات.
struct OnboardingInterestsView: View {

    // MARK: - Colors

    private let backgroundColor = Color(
        red: 0.96, green: 0.95, blue: 0.92
    )

    private let brown = Color(
        red: 0.42, green: 0.30, blue: 0.17
    )

    // MARK: - Environment

    // حالة التطبيق المسؤولة عن حفظ الاهتمامات وإكمال البداية.
    @Environment(AppState.self) private var appState

    // MARK: - ViewModel

    // نفس الكائن القادم من OnboardingView.
    // لا ننشئ ViewModel جديدًا داخل هذه الشاشة.
    let viewModel: OnboardingViewModel

    // MARK: - Navigation

    // الانتقال إلى صفحة أخرى عند الضغط على نقاط الصفحات.
    var onSelectPage: (Int) -> Void = { _ in }

    // MARK: - Local UI State

    // رقم البطاقة الظاهرة في المقدمة.
    // هذه حالة خاصة بالتصميم وليست بالاهتمامات المختارة.
    @State private var currentCard = 0

    // MARK: - Interests Data

    private let interests: [OnboardingInterest] = [

        OnboardingInterest(
            title: "الفن السعودي",
            subtitle: "السدو والقط العسيري",
            details: "رموز · ألوان · تكوين بصري",
            backgroundColor: Color(
                red: 0.99, green: 0.98, blue: 0.95
            ),
            type: .saudiArt
        ),

        OnboardingInterest(
            title: "الألعاب الإلكترونية",
            subtitle: "الخرائط والتحديات والاستراتيجية",
            details: "ذاكرة · تخيّل · تخطيط",
            backgroundColor: Color(
                red: 0.99, green: 0.98, blue: 0.95
            ),
            type: .gaming
        ),

        OnboardingInterest(
            title: "الرياضة",
            subtitle: "تعلّم المهارات والحركة والتوازن",
            details: "ذاكرة · انتباه · تناسق",
            backgroundColor: Color(
                red: 0.99, green: 0.98, blue: 0.95
            ),
            type: .sports
        )
    ]

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {

                // MARK: - Page Indicator

                HStack {
                    PageIndicator(
                        currentPage: 2,
                        onSelect: onSelectPage
                    )

                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 12)

                // MARK: - Title

                VStack(alignment: .trailing, spacing: 8) {

                    Text("ما اهتماماتك؟")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(brown)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .multilineTextAlignment(.trailing)

                    Text("قلب البطاقات واختر 3 أو أقل.")
                        .font(.system(size: 17))
                        .foregroundStyle(brown)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .multilineTextAlignment(.leading)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .environment(\.layoutDirection, .rightToLeft)
                .padding(.horizontal, 30)
                .padding(.top, 40)

                Spacer()
                    .frame(height: 30)

                // MARK: - Cards Stack

                ZStack {
                    ForEach(interests.indices, id: \.self) { index in

                        let relativeIndex =
                            (index - currentCard + interests.count)
                            % interests.count

                        InterestCardView(
                            interest: interests[index],
                            brown: brown,
                            isSelected: viewModel.selectedInterests.contains(
                                interests[index].interest
                            )
                        )
                        // اختيار البطاقة أو إلغاء اختيارها.
                        .onTapGesture {
                            toggle(interests[index].interest)
                        }
                        .frame(
                            width: geometry.size.width * 0.88,
                            height: geometry.size.height * 0.43
                        )
                        .scaleEffect(
                            relativeIndex == 0 ? 1.0 : 0.92
                        )
                        .offset(
                            x: CGFloat(relativeIndex) * 12,
                            y: CGFloat(relativeIndex) * -16
                        )
                        .opacity(
                            relativeIndex == 0 ? 1.0 : 0.90
                        )
                        .zIndex(
                            Double(interests.count - relativeIndex)
                        )
                        .allowsHitTesting(relativeIndex == 0)
                        .animation(
                            .easeInOut(duration: 0.35),
                            value: currentCard
                        )
                    }
                }
                // تصغير البطاقات عند ظهور صندوق الاختيارات.
                .scaleEffect(cardsScale)
                .frame(maxWidth: .infinity)
                .frame(
                    height: geometry.size.height * 0.45 * cardsScale
                )

                // MARK: - Change Card Button

                Button {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        currentCard =
                            (currentCard + 1) % interests.count
                    }
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(
                            .system(size: 19, weight: .semibold)
                        )
                        .foregroundStyle(brown)
                        .frame(width: 49, height: 49)
                        .background(.white)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(
                                    Color.gray.opacity(0.25),
                                    lineWidth: 0.8
                                )
                        }
                        .shadow(
                            color: .black.opacity(0.08),
                            radius: 5,
                            y: 2
                        )
                }
                .accessibilityLabel("البطاقة التالية")
                .padding(.top, -8)

                // MARK: - Selected Interests

                // يظهر صندوق اختياراتي بعد تحديد اهتمام واحد على الأقل.
                if !viewModel.selectedInterests.isEmpty {
                    SelectedInterestsView(
                        items: selectedItems,
                        maxCount: viewModel.maxSelection
                    ) { interest in
                        withAnimation(.easeInOut(duration: 0.25)) {
                            // الحذف يتم عبر ViewModel،
                            // وليس عن طريق حالة محلية في الشاشة.
                            viewModel.removeInterest(interest)
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 20)
                    .transition(
                        .opacity.combined(with: .scale(scale: 0.95))
                    )
                }

                Spacer(minLength: 20)

                // MARK: - Start Button

                // لا يمكن إكمال البداية قبل اختيار اهتمام واحد.
                PrimaryButton(
                    title: "ابدأ",
                    isDisabled: !viewModel.canFinish
                ) {
                    // ViewModel يحفظ الاهتمامات في AppState
                    // ثم يحدد أن المستخدم أكمل Onboarding.
                    viewModel.finish(using: appState)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 25)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .background(backgroundColor)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Selection

    // تصغير البطاقات عند اختيار اهتمام واحد أو أكثر.
    private var cardsScale: CGFloat {
        viewModel.selectedInterests.isEmpty ? 1.0 : 0.72
    }

    // تحويل الاهتمامات المختارة إلى بيانات صندوق "اختياراتي".
    // نستخدم ترتيب المصفوفة المحفوظ داخل ViewModel.
    private var selectedItems: [SelectedInterestsView.Item] {
        viewModel.selectedInterests.compactMap { interest in
            guard let card = interests.first(
                where: { $0.interest == interest }
            ) else {
                return nil
            }

            return .init(
                interest: interest,
                title: card.title
            )
        }
    }

    // اختيار الاهتمام أو إلغاء اختياره.
    private func toggle(_ interest: Interest) {
        withAnimation(.easeInOut(duration: 0.25)) {
            viewModel.toggleInterest(interest)
        }
    }
}

// MARK: - Interest Model

// البيانات المستخدمة لعرض بطاقات الاهتمامات.
private struct OnboardingInterest: Identifiable {

    enum InterestType {
        case saudiArt
        case gaming
        case sports
    }

    let id = UUID()
    let title: String
    let subtitle: String
    let details: String
    let backgroundColor: Color
    let type: InterestType

    // تحويل نوع البطاقة إلى Interest المستخدم في التطبيق.
    var interest: Interest {
        switch type {
        case .saudiArt:
            return .art
        case .gaming:
            return .gaming
        case .sports:
            return .sport
        }
    }
}

// MARK: - Interest Card View

// تصميم بطاقة الاهتمام.
// بقي كما هو، مع إظهار إطار بني عند تحديد البطاقة.
private struct InterestCardView: View {

    let interest: OnboardingInterest
    let brown: Color
    var isSelected: Bool = false

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Illustration

            InterestIllustration(
                type: interest.type,
                brown: brown
            )
            .frame(height: 125)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 17)
            .padding(.top, 22)

            Spacer(minLength: 20)

            // MARK: - Text

            VStack(alignment: .trailing, spacing: 10) {

                Text(interest.title)
                    .font(.system(size: 30, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(brown)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .multilineTextAlignment(.trailing)

                Text(interest.subtitle)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(brown)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .multilineTextAlignment(.trailing)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )

                Text(interest.details)
                    .font(.system(size: 14))
                    .foregroundStyle(brown.opacity(0.8))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal, 25)

            Spacer(minLength: 38)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(interest.backgroundColor)
        .clipShape(
            RoundedRectangle(cornerRadius: 34)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 34)
                .stroke(
                    isSelected ? brown : Color.white.opacity(0.9),
                    lineWidth: isSelected ? 3.5 : 1.5
                )
        }
        .shadow(
            color: .black.opacity(0.10),
            radius: 18,
            y: 8
        )
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Illustration Selector

// يحدد الرسم المناسب لنوع الاهتمام.
private struct InterestIllustration: View {

    let type: OnboardingInterest.InterestType
    let brown: Color

    var body: some View {
        Group {
            switch type {
            case .saudiArt:
                SaduIllustration()

            case .gaming:
                GamingIllustration()

            case .sports:
                SportsIllustration()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Saudi Art Illustration

// رسم هندسي مستوحى من السدو السعودي.
private struct SaduIllustration: View {

    private let colors: [Color] = [
        Color(red: 0.52, green: 0.22, blue: 0.18),
        Color(red: 0.87, green: 0.53, blue: 0.39),
        Color(red: 0.43, green: 0.56, blue: 0.49),
        Color(red: 0.52, green: 0.22, blue: 0.18),
        Color(red: 0.80, green: 0.61, blue: 0.53),
        Color(red: 0.43, green: 0.56, blue: 0.49),
        Color(red: 0.87, green: 0.53, blue: 0.39)
    ]

    var body: some View {
        VStack(spacing: 6) {

            Rectangle()
                .fill(
                    Color(red: 0.52, green: 0.22, blue: 0.18)
                )
                .frame(height: 5)

            Rectangle()
                .fill(
                    Color(red: 0.30, green: 0.23, blue: 0.18)
                )
                .frame(height: 2)

            HStack(spacing: -4) {
                ForEach(0..<colors.count, id: \.self) { index in
                    Triangle()
                        .fill(colors[index])
                        .frame(maxWidth: 48)
                        .frame(height: 65)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)

            Rectangle()
                .fill(
                    Color(red: 0.30, green: 0.23, blue: 0.18)
                )
                .frame(height: 2)

            Rectangle()
                .fill(
                    Color(red: 0.52, green: 0.22, blue: 0.18)
                )
                .frame(height: 9)
        }
    }
}

// MARK: - Gaming Illustration

// رسم خريطة مبسطة يرمز للألعاب والتخطيط.
private struct GamingIllustration: View {

    private let purple = Color(
        red: 0.66, green: 0.60, blue: 0.87
    )

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        Color(
                            red: 0.94,
                            green: 0.92,
                            blue: 0.97
                        )
                    )

                Path { path in
                    path.move(
                        to: CGPoint(
                            x: geometry.size.width * 0.12,
                            y: geometry.size.height * 0.70
                        )
                    )

                    path.addLine(
                        to: CGPoint(
                            x: geometry.size.width * 0.32,
                            y: geometry.size.height * 0.70
                        )
                    )

                    path.addLine(
                        to: CGPoint(
                            x: geometry.size.width * 0.32,
                            y: geometry.size.height * 0.30
                        )
                    )

                    path.addLine(
                        to: CGPoint(
                            x: geometry.size.width * 0.66,
                            y: geometry.size.height * 0.30
                        )
                    )

                    path.addLine(
                        to: CGPoint(
                            x: geometry.size.width * 0.66,
                            y: geometry.size.height * 0.62
                        )
                    )

                    path.addLine(
                        to: CGPoint(
                            x: geometry.size.width * 0.88,
                            y: geometry.size.height * 0.62
                        )
                    )
                }
                .stroke(
                    purple,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )

                Circle()
                    .fill(
                        Color(
                            red: 0.52,
                            green: 0.22,
                            blue: 0.18
                        )
                    )
                    .frame(width: 14, height: 14)
                    .position(
                        x: geometry.size.width * 0.12,
                        y: geometry.size.height * 0.70
                    )

                Circle()
                    .fill(
                        Color(
                            red: 0.43,
                            green: 0.56,
                            blue: 0.49
                        )
                    )
                    .frame(width: 18, height: 18)
                    .overlay {
                        Circle()
                            .stroke(.white, lineWidth: 3)
                    }
                    .position(
                        x: geometry.size.width * 0.88,
                        y: geometry.size.height * 0.62
                    )

                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .frame(width: 37, height: 37)
                    .overlay {
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(purple)
                    }
                    .position(
                        x: geometry.size.width * 0.50,
                        y: geometry.size.height * 0.72
                    )
            }
        }
    }
}

// MARK: - Sports Illustration

// رسم يرمز للحركة والتوازن في الأنشطة الرياضية.
private struct SportsIllustration: View {

    private let green = Color(
        red: 0.43, green: 0.56, blue: 0.49
    )

    private let peach = Color(
        red: 0.87, green: 0.53, blue: 0.39
    )

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        Color(
                            red: 0.92,
                            green: 0.95,
                            blue: 0.90
                        )
                    )

                Path { path in
                    path.move(
                        to: CGPoint(
                            x: geometry.size.width * 0.14,
                            y: geometry.size.height * 0.76
                        )
                    )

                    path.addQuadCurve(
                        to: CGPoint(
                            x: geometry.size.width * 0.86,
                            y: geometry.size.height * 0.76
                        ),
                        control: CGPoint(
                            x: geometry.size.width * 0.50,
                            y: geometry.size.height * 0.10
                        )
                    )
                }
                .stroke(
                    green.opacity(0.65),
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round,
                        dash: [5, 6]
                    )
                )

                Circle()
                    .fill(peach)
                    .frame(width: 17, height: 17)
                    .position(
                        x: geometry.size.width * 0.15,
                        y: geometry.size.height * 0.75
                    )

                Circle()
                    .fill(green)
                    .frame(width: 17, height: 17)
                    .position(
                        x: geometry.size.width * 0.85,
                        y: geometry.size.height * 0.75
                    )

                Image(systemName: "figure.run")
                    .font(.system(size: 65))
                    .foregroundStyle(green)
                    .position(
                        x: geometry.size.width * 0.50,
                        y: geometry.size.height * 0.48
                    )

                Circle()
                    .fill(.white)
                    .frame(width: 30, height: 30)
                    .overlay {
                        Image(systemName: "figure.cooldown")
                            .font(.system(size: 15))
                            .foregroundStyle(peach)
                    }
                    .position(
                        x: geometry.size.width * 0.78,
                        y: geometry.size.height * 0.23
                    )
            }
        }
    }
}

// MARK: - Triangle Shape

// شكل مثلث يستخدم في رسم زخرفة السدو.
private struct Triangle: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(x: rect.midX, y: rect.minY)
        )

        path.addLine(
            to: CGPoint(x: rect.maxX, y: rect.maxY)
        )

        path.addLine(
            to: CGPoint(x: rect.minX, y: rect.maxY)
        )

        path.closeSubpath()

        return path
    }
}

// MARK: - Preview

#Preview {
    OnboardingInterestsView(
        viewModel: OnboardingViewModel()
    )
    .environment(AppState())
}
