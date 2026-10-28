
// PageIndicator.swift - نقاط الصفحات في شاشات البداية.
//
// Contains:
// - Dots showing the current page.
// - Tapping a dot moves to its page.
//
// Used by: OnboardingView, OnboardingBenefitsView, OnboardingInterestsView.
// Learn: ForEach, closures, contentShape.

import SwiftUI

struct PageIndicator: View {

    // الصفحة الحالية (تبدأ من 0)
    let currentPage: Int

    // عدد الصفحات
    var pageCount: Int = 3

    // ينفذ عند الضغط على نقطة
    let onSelect: (Int) -> Void

    private let activeColor = Color(red: 0.25, green: 0.20, blue: 0.15)

    var body: some View {

        // في RTL أول نقطة تكون على اليمين = الصفحة الأولى
        HStack(spacing: 0) {

            ForEach(0..<pageCount, id: \.self) { page in

                Button {
                    onSelect(page)
                } label: {
                    Circle()
                        .fill(
                            page == currentPage
                                ? activeColor
                                : Color.gray.opacity(0.4)
                        )
                        .frame(width: 8, height: 8)
                        // مساحة ضغط أكبر من النقطة نفسها
                        .frame(width: 20, height: 28)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("الصفحة \(page + 1)")
                .accessibilityAddTraits(page == currentPage ? .isSelected : [])
            }
        }
        .padding(.horizontal, 8)
        .background(Color(red: 0.93, green: 0.91, blue: 0.87))
        .clipShape(Capsule())
    }
}

// MARK: - Preview

#Preview {
    PageIndicator(currentPage: 1) { page in
        print("Page \(page)")
    }
    .environment(\.layoutDirection, .rightToLeft)
}
