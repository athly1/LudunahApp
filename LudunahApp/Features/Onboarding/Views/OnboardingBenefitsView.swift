
import SwiftUI

struct OnboardingBenefitsView: View {

    // MARK: - Colors

    private let brown = Color(red: 0.42, green: 0.30, blue: 0.17)
    private let backgroundColor = Color(red: 0.96, green: 0.95, blue: 0.92)
    private let cardColor = Color(red: 0.99, green: 0.985, blue: 0.97)

    // ينفذ عند الضغط على "التالي"
    var onNext: () -> Void = {}

    // ينفذ عند الضغط على نقطة صفحة
    var onSelectPage: (Int) -> Void = { _ in }

    var body: some View {

        GeometryReader { geometry in

            VStack(spacing: 0) {

                // MARK: - Page Indicator

                // في RTL أول عنصر يكون على اليمين، لذلك النقاط قبل الـ Spacer
                HStack {
                    PageIndicator(currentPage: 1, onSelect: onSelectPage)

                    Spacer()
                }
                .padding(.top, 12)
                .padding(.horizontal, 24)

                // MARK: - Title and Description

                VStack(alignment: .leading, spacing: 10) {

                    Text("تمارين قصيرة تناسبك")
                        .font(.system(size: 29, weight: .bold))
                        .foregroundStyle(brown)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)

                    Text("كل يوم بضع دقائق فقط، والتطبيق يضبط التمرين حسب طاقتك واهتماماتك.")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(brown.opacity(0.9))
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .environment(\.layoutDirection, .rightToLeft)
                .padding(.horizontal, 28)
                .padding(.top, 38)

                // MARK: - Benefit Cards

                VStack(spacing: 18) {

                    BenefitCard(
                        title: "5 دقائق يوميًا",
                        description: "تمارين ذهنية خفيفة تناسب يومك.",
                        icon: "clock",
                        iconColor: Color(red: 0.98, green: 0.90, blue: 0.85)
                    )

                    BenefitCard(
                        title: "تتكيف معك",
                        description: "الصعوبة تتغيّر حسب مستواك وطاقتك اليوم.",
                        icon: "person.fill.checkmark",
                        iconColor: Color(red: 0.93, green: 0.91, blue: 0.97)
                    )

                    BenefitCard(
                        title: "شاهد تقدمك",
                        description: "رسوم بيانية تلخّص إنجازك على مدار الشهر.",
                        icon: "chart.bar",
                        iconColor: Color(red: 0.90, green: 0.93, blue: 0.87)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 44)

                Spacer(minLength: 20)

                // MARK: - Next Button

                PrimaryButton(title: "التالي", action: onNext)
                .padding(.horizontal, 40)
                .padding(.bottom, 18)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Benefit Card

private struct BenefitCard: View {

    let title: String
    let description: String
    let icon: String
    let iconColor: Color

    private let brown = Color(red: 0.42, green: 0.30, blue: 0.17)

    var body: some View {

        HStack(spacing: 14) {

            // Text

            VStack(alignment: .leading, spacing: 6) {

                Text(title)
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(brown)

                Text(description)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(brown.opacity(0.88))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Icon

            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(brown)
                .frame(width: 52, height: 52)
                .background(iconColor)
                .clipShape(RoundedRectangle(cornerRadius: 13))
        }
        .environment(\.layoutDirection, .rightToLeft)
        .padding(.horizontal, 18)
        .padding(.vertical, 17)
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color(red: 0.99, green: 0.985, blue: 0.97))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(
            color: brown.opacity(0.035),
            radius: 9,
            x: 0,
            y: 4
        )
    }
}

// MARK: - Preview

#Preview {
    OnboardingBenefitsView()
}
