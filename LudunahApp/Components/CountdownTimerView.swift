
// CountdownTimerView.swift - المؤقت الدائري المشترك.
//
// Contains:
// - English time display (MM:SS).
// - Circular progress countdown.
// - Optional RTL direction.
// - Finished text inside the circle.
// - Optional caption below the circle.
//
// Used by: ArtDoView, GamingDoView, SportDoView.

import SwiftUI

// MARK: - Countdown Timer View

struct CountdownTimerView: View {

    // MARK: - Properties

    // محرك العد التنازلي
    @ObservedObject var engine: TimerEngine

    // لون الدائرة
    var color: Color = .artTimerRing

    // حجم الدائرة
    var size: CGFloat = 145

    // اتجاه حركة الدائرة
    // false = الاتجاه الأصلي للفريق
    // true = الاتجاه المعكوس RTL
    var isRTL: Bool = false

    // التحكم بالنص الموجود تحت الدائرة
    var showsFinishedCaption: Bool = true

    // MARK: - Formatted Time

    // تنسيق الوقت بالأرقام الإنجليزية
    private var formattedTime: String {

        let minutes = engine.remainingTime / 60
        let seconds = engine.remainingTime % 60

        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }

    // MARK: - Progress

    // نسبة الوقت المتبقي
    private var progress: CGFloat {

        guard engine.duration > 0 else {
            return 0
        }

        return CGFloat(engine.remainingTime)
            / CGFloat(engine.duration)
    }

    // MARK: - Body

    var body: some View {

        VStack(spacing: 20) {

            ZStack {

                // خلفية بيضاء
                Circle()
                    .fill(Color.white)

                // مسار الدائرة الخلفي
                Circle()
                    .stroke(
                        color.opacity(0.18),
                        lineWidth: 4
                    )

                // دائرة العد التنازلي
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        color,
                        style: StrokeStyle(
                            lineWidth: 6,
                            lineCap: .round
                        )
                    )

                    // بدء الدائرة من أعلى
                    .rotationEffect(.degrees(-90))

                    // عكس الاتجاه فقط عند تفعيل RTL
                    .scaleEffect(
                        x: isRTL ? -1 : 1,
                        y: 1
                    )

                    // ظل الدائرة
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: 8,
                        x: 2,
                        y: 8
                    )

                // MARK: - Time Text

                if engine.isFinished {

                    // عند انتهاء الوقت
                    Text("انتهى الوقت")
                        .font(
                            .custom(
                                "thmanyah sans",
                                size: 20
                            )
                            .weight(.bold)
                        )
                        .foregroundStyle(color)
                        .multilineTextAlignment(.center)

                } else {

                    // عرض الوقت بالأرقام الإنجليزية
                    Text(formattedTime)
                        .font(
                            .custom(
                                "thmanyah sans",
                                size: 34
                            )
                            .weight(.bold)
                        )
                        .monospacedDigit()
                        .foregroundStyle(Color.textPrimary)

                        // تثبيت ترتيب MM:SS
                        .environment(
                            \.layoutDirection,
                            .leftToRight
                        )
                        .environment(
                            \.locale,
                            Locale(identifier: "en_US")
                        )
                }
            }

            // حجم الدائرة الموحد
            .frame(
                width: size,
                height: size
            )
            .tint(color)

            // نص اختياري تحت الدائرة
            if engine.isFinished && showsFinishedCaption {

                Text("انتهى الوقت")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(color)
            }
        }
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Preview

#Preview {

    CountdownTimerView(
        engine: TimerEngine(duration: 300),
        color: .artTimerRing,
        size: 145,
        isRTL: true,
        showsFinishedCaption: false
    )
    .padding(Spacing.space24)
    .frame(
        maxWidth: .infinity,
        maxHeight: .infinity
    )
    .background(Color.pageBackground)
}
