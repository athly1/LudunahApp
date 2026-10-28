//
//  SelectedInterestsView.swift
//  LudunahApp
//
//  Created by Athari Alotaibi on 17/05/1448 AH.
//

import SwiftUI

// MARK: - Selected Interests Box

// صندوق "اختياراتي" يعرض الاهتمامات المختارة مع زر × لحذف كل اختيار
struct SelectedInterestsView: View {

    // اهتمام مختار مع الاسم الظاهر على البطاقة
    struct Item: Identifiable {
        let interest: Interest
        let title: String

        var id: Interest { interest }
    }

    // الاختيارات بالترتيب
    let items: [Item]

    // أقصى عدد للاختيارات
    var maxCount: Int = 3

    // ينفذ عند الضغط على ×
    let onRemove: (Interest) -> Void

    private let brown = Color(red: 0.42, green: 0.30, blue: 0.17)

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            // العنوان والعدد
            HStack {

                Text("اختياراتي")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(brown)

                Spacer()

                Text("\(items.count) من \(maxCount)")
                    .font(.system(size: 16))
                    .foregroundStyle(brown)
            }

            // كبسولات الاختيارات
            FlowLayout(spacing: 8) {

                ForEach(items) { item in
                    SelectedChip(
                        title: item.title,
                        color: chipColor(for: item.interest),
                        brown: brown
                    ) {
                        onRemove(item.interest)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.99, green: 0.985, blue: 0.97))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }

    // لون الكبسولة لكل اهتمام
    private func chipColor(for interest: Interest) -> Color {
        switch interest {
        case .art:
            return .artChipBackground
        case .sport:
            return .sportChip
        case .gaming:
            return .gamingChip
        }
    }
}

// MARK: - Selected Chip

// كبسولة اختيار واحدة مع زر الحذف
private struct SelectedChip: View {

    let title: String
    let color: Color
    let brown: Color
    let onRemove: () -> Void

    var body: some View {

        HStack(spacing: 10) {

            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(brown)

            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color(red: 0.52, green: 0.22, blue: 0.18))
                    .frame(width: 24, height: 24)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("حذف \(title)")
        }
        .padding(.leading, 18)
        .padding(.trailing, 12)
        .padding(.vertical, 9)
        .background(color, in: Capsule())
    }
}

// MARK: - Preview

#Preview {
    SelectedInterestsView(
        items: [
            .init(interest: .art, title: "الفن السعودي"),
            .init(interest: .sport, title: "الرياضة")
        ],
        onRemove: { _ in }
    )
    .padding()
    .background(Color(red: 0.96, green: 0.95, blue: 0.92))
    .environment(\.layoutDirection, .rightToLeft)
}
