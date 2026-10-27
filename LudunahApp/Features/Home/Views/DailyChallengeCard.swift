//
//  DailyChallengeCard.swift
//  LudunahApp
//
//  Created by nuha on 27/10/2026.
//


import SwiftUI

struct DailyChallengeCard: View {
    let title: String
    let category: String
    let minutes: Int
    let isCompleted: Bool
    let iconName: String
    let iconColor: Color
    let onSwap: () -> Void
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: Spacing.space16) {

            // أيقونة التحدي
            Image(systemName: iconName)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(iconColor)
                .frame(width: 48, height: 48)
                .background(iconColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            // تفاصيل التحدي
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.titleCards)
                        .foregroundStyle(Color.textPrimary)

                    Text("\(category) · \(minutes) دقائق")
                        .font(.caption)
                        .foregroundStyle(Color.appSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // تبديل التحدي
            Button(action: onSwap) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.appSecondary)
                    .frame(width: 32, height: 40)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("تبديل التحدي")

            // حالة الإنجاز
            Image(
                systemName: isCompleted
                    ? "checkmark.circle.fill"
                    : "circle"
            )
            .font(.system(size: 22))
            .foregroundStyle(
                isCompleted ? Color.appSecondary : Color.textPrimary.opacity(0.4)
            )
        }
        .padding(Spacing.space16)
        .background(Color.pageBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.appSecondary.opacity(0.2), lineWidth: 1)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

