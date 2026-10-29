
import SwiftUI

struct DailyChallengeCard: View {
    let title: String
    let category: String
    let minutes: Int
    let isCompleted: Bool

    let iconName: String
    let iconBackground: Color

    let onSwap: () -> Void
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: Spacing.space16) {

            // البطاقة نفسها
            HStack(spacing: Spacing.space16) {

                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 54)
                    .background(iconBackground)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 16,
                            style: .continuous
                        )
                    )
                    .accessibilityHidden(true)

                // تفاصيل التحدي
                Button(action: onTap) {
                    VStack(
                        alignment: .leading,
                        spacing: Spacing.space8
                    ) {
                        Text(title)
                            .font(.challengeCardTitle)
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )

                        Text("\(category) · \(minutes) دقائق")
                            .font(.challengeCardSubtitle)
                            .foregroundStyle(Color.appSecondary)
                            .lineLimit(1)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                // حالة الإنجاز
                Image(
                    systemName: isCompleted
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.system(size: 24))
                .foregroundStyle(
                    isCompleted
                        ? Color.actionPrimary
                        : Color.challengeRadioInactive
                )
                .frame(width: 24, height: 24)
                .accessibilityLabel(
                    isCompleted ? "مكتمل" : "غير مكتمل"
                )
            }
            .padding(.horizontal, Spacing.space16)
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            .background(Color.glassBackground)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 25,
                    style: .continuous
                )
            )
            .shadow(
                color: Color.black.opacity(0.06),
                radius: 10,
                x: 0,
                y: 4
            )

            // زر التبديل خارج البطاقة
            Button(action: onSwap) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.appSecondary)
                    .frame(width: 20, height: 28)
                    .contentShape(Circle())
            }
            .buttonStyle(.glass)
            .frame(width: 30, height: 30)
            .accessibilityLabel("تبديل التحدي")
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
