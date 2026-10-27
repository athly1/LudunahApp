import SwiftUI

/// صفحة التعلّم في نشاط الرياضة.
/// تُستخدم داخل مسار النشاط، وتستقبل إجراء الرجوع من الشاشة الأم.
struct SportLearnView: View {

    var onBack: () -> Void = {}

    private let progress: CGFloat = 1.0 / 3.0

    var body: some View {
        VStack(spacing: Spacing.space24) {
            ActivityHeader(
                interestTitle: Interest.sport.title,
                interestColor: .sportTint,
                stepTitle: "تعلّم",
                stepIcon: "lightbulb.max",
                onBack: onBack
            )

            progressBar
                .padding(.top, Spacing.space8)

            Text("كيف تساعد كرة القدم على تحسين لياقتك؟")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, Spacing.space16)

            learningCard
                .padding(.top, Spacing.space24)

            Spacer(minLength: Spacing.space24)

            Image(systemName: "hand.tap")
                .font(.system(size: 48, weight: .regular))
                .foregroundStyle(Color.textPrimary)
                .accessibilityLabel("اسحب للانتقال إلى الخطوة التالية")
                .padding(.bottom, Spacing.space32)
        }
        .padding(.horizontal, Spacing.pageMargin)
        .padding(.top, Spacing.space16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pageBackground.ignoresSafeArea())
        .environment(\.layoutDirection, .rightToLeft)
    }

    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                Capsule()
                    .fill(Color.progressBarInactive)

                Capsule()
                    .fill(Color.actionPrimary)
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(height: 8)
        .accessibilityElement()
        .accessibilityLabel("التقدم")
        .accessibilityValue("الخطوة الأولى من ثلاث")
    }

    private var learningCard: some View {
        VStack(spacing: Spacing.space12) {
            Image(systemName: "soccerball")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(Color.sportFieldBall)
                .frame(width: 46, height: 46)
                .background(Color.sportTint, in: RoundedRectangle(cornerRadius: 18))
                .accessibilityHidden(true)

            Text("تساعد كرة القدم على تحسين اللياقة البدنية وتقوية العضلات، وتعزز التوازن بين حركة العين والقدم، كما تمنحك فرصة للتعاون مع فريقك واتخاذ قرارات سريعة أثناء اللعب.")
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, Spacing.space24)
        .padding(.vertical, Spacing.space16)
        .frame(maxWidth: .infinity, minHeight: 230)
        .background(Color.glassBackground, in: RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 9)
    }
}

#Preview {
    SportLearnView()
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}

