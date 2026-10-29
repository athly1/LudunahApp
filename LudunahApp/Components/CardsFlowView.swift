
// CardsFlowView.swift - بطاقات التعلم القابلة للسحب.
//
// Contains:
// - Shared learning information card.
// - Swipe-up navigation between cards.
// - Animated swipe hint.
// - Unified spacing for Art, Gaming and Sport.
//
// Used by: ArtLearnView, GamingLearnView, SportLearnView.
//
// Learn: ScrollView, VStack, DragGesture,
//        phaseAnimator, transitions.

import SwiftUI

// MARK: - One Card Build

struct InfoCard: View {

    // MARK: - Properties

    // اسم أيقونة البطاقة
    let CardIcon: String

    // لون خلفية الأيقونة
    let iconBackground: Color

    // لون الأيقونة
    var iconColor: Color

    // النص داخل البطاقة
    let text: String

    // MARK: - Body

    var body: some View {

        VStack(spacing: 12) {

            // الأيقونة داخل مستطيل بحواف دائرية
            Image(systemName: CardIcon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(iconColor)
                .frame(width: 48, height: 37)
                .background(iconBackground)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )

            // محتوى البطاقة
            Text(text)
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
        .shadow(
            color: .black.opacity(0.12),
            radius: 12,
            x: 0,
            y: 8
        )
    }
}

// MARK: - Swipe Up Learning Cards

struct CardsFlowView: View {

    // MARK: - Properties

    // لون الأيقونة
    var iconColor: Color

    // لون خلفية الأيقونة
    var iconActivityBackground: Color

    // بطاقات النشاط بالترتيب
    let cards: [ActivityCard]

    // رقم البطاقة الحالية
    let index: Int

    // دالة الانتقال إلى البطاقة التالية
    var onNext: () -> Void

    // MARK: - Body

    var body: some View {

        ScrollView {

            // المسافة موحدة بين جميع أنشطة Learn
            VStack(spacing: 145) {

                // التأكد من وجود البطاقة الحالية
                if cards.indices.contains(index) {

                    let card = cards[index]

                    // MARK: - Information Card

                    InfoCard(
                        CardIcon: card.icon,
                        iconBackground: iconActivityBackground,
                        iconColor: iconColor,
                        text: card.text
                    )
                    .id(index)
                    .transition(.push(from: .bottom))
                    .frame(maxWidth: .infinity)

                    // MARK: - Swipe Hint

                    // إظهار أيقونة السحب باستثناء آخر بطاقة
                    if index < cards.count - 1 {

                        Image(systemName: "hand.draw")
                            .font(.system(size: 42))
                            .foregroundStyle(Color.textPrimary)
                            .rotationEffect(.degrees(15))

                            // تحريك اليد للأعلى والأسفل
                            .phaseAnimator([false, true]) {
                                content, isUp in

                                content.offset(
                                    y: isUp ? -30 : 0
                                )

                            } animation: { _ in

                                .easeInOut(duration: 0.8)
                            }
                    }
                }
            }

            // MARK: - Layout

            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)

            // جعل مساحة البطاقات تستجيب للسحب
            .contentShape(Rectangle())

            // MARK: - Swipe Gesture

            .gesture(

                DragGesture().onEnded { drag in

                    // الانتقال عند السحب للأعلى
                    // لمسافة تتجاوز 80 نقطة
                    if drag.translation.height < -80 &&
                        index < cards.count - 1 {

                        onNext()
                    }
                }
            )

            // دعم اللغة العربية
            .environment(
                \.layoutDirection,
                .rightToLeft
            )
        }

        // إخفاء مؤشر التمرير
        .scrollIndicators(.hidden)
    }
}
