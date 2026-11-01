
// ArtLearnView.swift - واجهة تعلّم الفن السعودي.
//
// Contains:
// - Shared ActivityHeader.
// - Progress bar.
// - Activity image from Assets.
// - Swipe-up learning cards.
// - Previous and next card navigation.
// - Record completed Art Learn activity.
// - Finish button on the last card.
//
// Used by: InstructionsSheet (art, learn).
//
// Learn: @StateObject, @State, @Environment,
//        Image, CardsFlowView, ProgressView,
//        StorageService

import SwiftUI

// MARK: - Art Learn View

struct ArtLearnView: View {

    // MARK: - Properties

    // ViewModel الخاص ببطاقات التعلم
    @StateObject private var viewModel: ArtLearnViewModel

    // منع تسجيل الإنجاز أكثر من مرة
    @State private var didFinish = false

    // MARK: - Initialization

    init(activityID: String? = nil) {
        _viewModel = StateObject(
            wrappedValue: ArtLearnViewModel(
                activityID: activityID
            )
        )
    }

    // MARK: - Environment

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

                    // الرجوع إلى البطاقة السابقة
                    if viewModel.index > 0 {
                        withAnimation {
                            viewModel.previousCard()
                        }
                    } else {
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

            if let imageName = viewModel.imageName {

                GeometryReader { geometry in

                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: 160
                        )

                        // تكبير صورة الفسيفساء فقط
                        .scaleEffect(
                            imageName == "art_mosaic" ? 1.15 : 1.0
                        )

                        .frame(
                            width: geometry.size.width,
                            height: 160
                        )

                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )

                        .shadow(
                            color: .black.opacity(0.12),
                            radius: 12,
                            x: 0,
                            y: 4
                        )
                }
                .frame(height: 160)
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.bottom, Spacing.space12)
            }

            // MARK: - Learning Cards

            if !viewModel.cards.isEmpty {

                CardsFlowView(
                    iconColor: .textPrimary,
                    iconActivityBackground: .artChipBackground,
                    cards: viewModel.cards,
                    index: viewModel.index,
                    onNext: {
                        withAnimation {
                            viewModel.nextCard()
                        }
                    }
                )
                .frame(maxHeight: .infinity)

            } else if let error = viewModel.errorMessage {

                // رسالة في حال فشل تحميل النشاط
                Text(error)
                    .font(.titleCards)
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(Spacing.pageMargin)

                Spacer()
            }

            // MARK: - Finish Button

            // يظهر فقط عند الوصول إلى آخر بطاقة
            if viewModel.isLastCard {

                PrimaryButton(title:  "اتمام التحدي") {

                    finishActivity()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.top, Spacing.space8)
                .padding(.bottom, Spacing.pageMargin)
            }
        }

        // MARK: - Layout

        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )

        .background(
            Color.pageBackground.ignoresSafeArea()
        )

        // إخفاء شريط التنقل الافتراضي
        .toolbar(.hidden, for: .navigationBar)

        // دعم اللغة العربية
        .environment(
            \.layoutDirection,
            .rightToLeft
        )
    }
    // MARK: - Finish Activity

    private func finishActivity() {
        guard !didFinish, viewModel.isLastCard else {
            return
        }

        didFinish = true

        StorageService().recordCompletedActivity(
            interest: .art
        )

        dismiss()
    }

}

// MARK: - Preview

#Preview {

    NavigationStack {

        NavigationLink("افتح تعلّم الفن") {

            ArtLearnView()
        }
    }
    .environment(
        \.layoutDirection,
        .rightToLeft
    )
}
