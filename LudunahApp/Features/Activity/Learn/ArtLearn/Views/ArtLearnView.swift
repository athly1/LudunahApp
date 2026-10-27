
// ArtLearnView.swift - واجهة تعلّم الفن السعودي.
//
// Contains:
// - Shared ActivityHeader.
// - Progress bar.
// - Activity image from Assets.
// - Swipe-up learning cards.
// - Finish button on the last card.
//
// Used by: ActivityFlowView (art, learn).
// Learn: @StateObject, @Environment,
//       Image, CardsFlowView, ProgressView.

import SwiftUI

// MARK: - Art Learn View

struct ArtLearnView: View {

    // MARK: - Properties

    // ViewModel مثل Gaming Learn
    @StateObject private var viewModel = ArtLearnViewModel()

    // الرجوع للشاشة السابقة
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Shared Header

            ActivityHeader(
                interestTitle: "الفن السعودي",
                interestColor: .artChipBackground,
                stepTitle: "تعلّم",
                stepIcon: "lightbulb.max",
                onBack: {

                    // الرجوع للبطاقة السابقة
                    if viewModel.index > 0 {

                        withAnimation {
                            viewModel.previousCard()
                        }

                    } else {

                        // الرجوع للشاشة السابقة
                        dismiss()
                    }
                }
            )
            .padding(.horizontal, Spacing.pageMargin)
            .padding(.top, Spacing.space16)

            // MARK: - Progress Bar

            ProgressView(
                value: viewModel.currentProgress,
                total: Double(max(viewModel.totalCards, 1))
            )
            .tint(Color.actionPrimary)
            .padding(.horizontal, Spacing.pageMargin)
            .padding(.top, Spacing.space16)

            // MARK: - Activity Title

            Text(viewModel.title)
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.top, Spacing.space16)
                .padding(.bottom, Spacing.space12)

            // MARK: - Activity Image

            // عرض صورة الفسيفساء أو القط العسيري
            if let imageName = viewModel.imageName {

                Image(imageName)

                    // السماح بتغيير حجم الصورة
                    .resizable()

                    // المحافظة على أبعادها
                    .scaledToFit()

                    // حجم مناسب داخل الشاشة
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: 160
                    )

                    // زوايا دائرية
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )

                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.bottom, Spacing.space12)
            }

            // MARK: - Learning Cards

            if !viewModel.cards.isEmpty {

                // نفس المكون المستخدم في Gaming Learn
                CardsFlowView(
                    iconColor: .textPrimary,
                    iconActivityBackground: .artChipBackground,
                    cards: viewModel.cards,
                    index: viewModel.index,
                    onNext: {

                        // الانتقال عند السحب للأعلى
                        withAnimation {
                            viewModel.nextCard()
                        }
                    }
                )
                .frame(maxHeight: .infinity)

            } else if let error = viewModel.errorMessage {

                // رسالة إذا فشل تحميل المحتوى
                Text(error)
                    .font(.titleCards)
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(Spacing.pageMargin)

                Spacer()
            }

            // MARK: - Finish Button

            // يظهر عند الوصول إلى آخر بطاقة
            if viewModel.isLastCard {

                PrimaryButton(title: "أنهيت") {

                    // الرجوع للشاشة السابقة
                    dismiss()
                }

                .frame(maxWidth: .infinity)
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.top, Spacing.space8)
                .padding(.bottom, Spacing.pageMargin)
            }
        }

        // تمديد الشاشة للمساحة المتاحة
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )

        // خلفية Design System
        .background(
            Color.pageBackground.ignoresSafeArea()
        )

        // استخدام ActivityHeader بدل Navigation Bar
        .toolbar(.hidden, for: .navigationBar)

        // دعم اللغة العربية
        .environment(
            \.layoutDirection,
            .rightToLeft
        )
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        NavigationLink("افتح تعلّم الفن") {

            ArtLearnView()
        }
    }
    .environment(\.layoutDirection, .rightToLeft)
}
