
// InterestChip.swift - عرض واختيار الاهتمامات.
//
// Contains:
// - InterestChip displaying all interests.
// - InterestOneChip for a single interest.
// - FlowLayout for wrapping items.
//
// Used by: OnboardingView, SettingsView.
// Learn: closures, ForEach, Layout, Set.

import SwiftUI

// MARK: - InterestChip

// يعرض جميع الاهتمامات
struct InterestChip: View {

    // الاهتمامات المحددة من الـ ViewModel
    let selectedInterests: Set<Interest>

    // الإجراء عند الضغط على اهتمام
    let onToggle: (Interest) -> Void

    var body: some View {

        // ترتيب الكبسولات في صفوف
        FlowLayout(spacing: Spacing.space8) {

            // إنشاء كبسولة لكل اهتمام
            ForEach(Interest.allCases) { interest in

                InterestOneChip(
                    interest: interest,
                    isSelected: selectedInterests.contains(interest)
                ) {
                    // إرسال الاهتمام المختار للشاشة الأم
                    onToggle(interest)
                }
            }
        }
    }
}

// MARK: - InterestOneChip

// كبسولة اهتمام واحدة
struct InterestOneChip: View {

    // نوع الاهتمام
    let interest: Interest

    // هل الاهتمام محدد؟
    let isSelected: Bool

    // الوظيفة عند الضغط
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            Text(interest.title)
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)

                // المسافات داخل الكبسولة
                .padding(.horizontal, Spacing.space16)
                .padding(.vertical, Spacing.space12)

                // خلفية تتغير عند الاختيار
                .background(
                    isSelected
                        ? selectedColor.opacity(0.7)
                        : Color.interestCardBg,
                    in: Capsule()
                )

                // حدود الكبسولة
                .overlay {
                    Capsule()
                        .stroke(
                            isSelected ? Color.clear : Color.gray.opacity(0.5),
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
    }

    // اللون المخصص لكل اهتمام
    private var selectedColor: Color {
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

// MARK: - FlowLayout

// ترتيب العناصر تلقائيًا على عدة صفوف
struct FlowLayout: Layout {

    // المسافة بين العناصر
    var spacing: CGFloat = 8

    // حساب الحجم المطلوب
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {

        let maxWidth = proposal.width ?? .infinity

        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widest: CGFloat = 0

        for view in subviews {

            // قياس العنصر
            let size = view.sizeThatFits(.unspecified)

            // الانتقال إلى صف جديد عند الحاجة
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }

            // حساب موقع العنصر التالي
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            widest = max(widest, x - spacing)
        }

        // الحجم النهائي
        return CGSize(
            width: widest,
            height: y + rowHeight
        )
    }

    // تحديد مواقع العناصر
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {

        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {

            let size = view.sizeThatFits(.unspecified)

            // بدء صف جديد إذا انتهت المساحة
            if x + size.width > bounds.maxX && x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            // وضع العنصر في مكانه
            view.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(size)
            )

            // تحديث إحداثيات العنصر القادم
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - Preview

#Preview {
    InterestChip(
        selectedInterests: [.art],
        onToggle: { interest in
            print("Selected: \(interest.title)")
        }
    )
    .padding()
    .environment(\.layoutDirection, .rightToLeft)
}
