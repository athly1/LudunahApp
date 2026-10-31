
// PrimaryButton.swift - الزر الرئيسي لتطبيق لُدُونه.
//
// Contains:
// - Reusable primary button.
// - Custom title and action.
// - Disabled state.
// - Design System styling.
// Shared button used across onboarding, activity,
// home, and instruction screens.
// Learn: Button, closure, disabled.

import SwiftUI

struct PrimaryButton: View {

    // عنوان الزر
    let title: String

    // هل الزر معطل؟
    var isDisabled: Bool = false

    // الدالة التي تنفذ عند الضغط
    let action: () -> Void

    var body: some View {

        // تنفيذ الوظيفة التي استقبلناها
        Button(action: action) {

            Text(title)
                .font(.primaryButton)
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(minHeight: Spacing.controlHeight - 12 )
        }

        // تصميم Liquid Glass
        .buttonStyle(.glass)

        // أقصى عرض للزر
        .frame(maxWidth: Spacing.ButtonWidth)

        // تعطيل الزر عند الحاجة
        .disabled(isDisabled)

        // تقليل الشفافية عند التعطيل
        .opacity(isDisabled ? 0.5 : 1)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.space16) {

        PrimaryButton(title: "التالي") {
            print("Next tapped")
        }

        PrimaryButton(
            title: "ابدأ",
            isDisabled: true
        ) {
            print("Start tapped")
        }
    }
    .padding()
    .background(Color.pageBackground)
}
