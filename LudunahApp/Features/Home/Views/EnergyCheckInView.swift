import SwiftUI

// MARK: - Energy Check-In

/// شريط تحديد الطاقة: ثلاثة مقاطع تمتلئ تدريجيًا حسب القيمة.
/// الاتجاه من اليمين لليسار: المنخفضة على اليمين والعالية على اليسار.
struct EnergyCheckInView: View {

    // MARK: - Input

    @Binding var energyValue: Int

    // MARK: - Layout

    private let thumbWidth: CGFloat = 56
    private let thumbHeight: CGFloat = 32
    private let barHeight: CGFloat = 16
    private let segmentSpacing: CGFloat = 4

    // MARK: - Derived

    private var level: EnergyLevel {
        EnergyLevel.from(value: energyValue)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .trailing, spacing: Spacing.space8) {

            // عنوان القسم بمحاذاة اليمين
            HStack {
                Spacer(minLength: 0)

                Text("اسحب لتحديد طاقتك")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .environment(\.layoutDirection, .leftToRight)

            energySlider
        }
        // اهتزاز خفيف عند الانتقال بين المستويات
        .sensoryFeedback(.selection, trigger: level)
    }

    // MARK: - Slider

    private var energySlider: some View {
        GeometryReader { geometry in

            let width = geometry.size.width
            let travel = max(width - thumbWidth, 1)
            let progress = CGFloat(energyValue) / 100

            // مركز المؤشر: القيمة العالية على اليسار
            let thumbCenter = thumbWidth / 2 + (1 - progress) * travel

            ZStack(alignment: .leading) {

                // المقاطع الثلاثة (من اليسار: عالية، متوسطة، منخفضة)
                HStack(spacing: segmentSpacing) {

                    EnergySegment(
                        color: EnergyLevel.high.color,
                        fill: segmentFill(from: 200.0 / 3.0)
                    )

                    EnergySegment(
                        color: EnergyLevel.medium.color,
                        fill: segmentFill(from: 100.0 / 3.0)
                    )

                    EnergySegment(
                        color: EnergyLevel.low.color,
                        fill: segmentFill(from: 0)
                    )
                }
                .frame(height: barHeight)

                // مؤشر الطاقة والنسبة المئوية
                Capsule()
                    .fill(level.color)
                    .frame(width: thumbWidth, height: thumbHeight)
                    .overlay {
                        Text(
                            energyValue,
                            format: .percent
                                .scale(1)
                                .precision(.fractionLength(0))
                        )
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.pageBackground)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                    }
                    .overlay {
                        Capsule()
                            .stroke(Color.pageBackground, lineWidth: 2)
                    }
                    .offset(x: thumbCenter - thumbWidth / 2)
            }
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let x = value.location.x - thumbWidth / 2
                        let percentage = (1 - x / travel) * 100

                        energyValue = min(max(Int(percentage.rounded()), 0), 100)
                    }
            )
            .animation(.snappy(duration: 0.15), value: energyValue)
        }
        .frame(height: 40)
        .environment(\.layoutDirection, .leftToRight)

        // VoiceOver
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("مستوى الطاقة")
        .accessibilityValue("\(energyValue)%")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                energyValue = min(energyValue + 10, 100)
            case .decrement:
                energyValue = max(energyValue - 10, 0)
            @unknown default:
                break
            }
        }
    }

    // MARK: - Segment Fill

    /// نسبة امتلاء مقطع يبدأ عند `lowerBound` ويغطي ثلث القيم.
    private func segmentFill(from lowerBound: Double) -> Double {
        let value = Double(energyValue)
        let segmentRange = 100.0 / 3.0

        return min(max((value - lowerBound) / segmentRange, 0), 1)
    }
}

// MARK: - Energy Segment

/// مقطع واحد من الشريط: خلفية باهتة ومعبأة بلونها من اليمين.
private struct EnergySegment: View {

    let color: Color

    /// من 0 إلى 1
    let fill: Double

    var body: some View {
        Capsule()
            .fill(color.opacity(0.4))
            .overlay {
                GeometryReader { geometry in
                    Capsule()
                        .fill(color)
                        .frame(width: geometry.size.width * fill)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .trailing
                        )
                }
            }
            .clipShape(Capsule())
    }
}

// MARK: - Energy Level Presentation

extension EnergyLevel {

    /// لون المستوى
    var color: Color {
        switch self {
        case .low:
            return Color.artPalette1
        case .medium:
            return Color.artPalette3
        case .high:
            return Color.sportFieldBall
        }
    }

    /// نوع التحديات المقترحة لهذا المستوى
    var suggestedTypeTitle: String {
        switch self {
        case .low:
            return "تحديات تعلّم"
        case .medium:
            return "تحديات ابتكار"
        case .high:
            return "تحديات تطبيق"
        }
    }

    /// أيقونة النوع (SF Symbols)
    var suggestedTypeIcon: String {
        switch self {
        case .low:
            return "lightbulb"
        case .medium:
            return "sparkles"
        case .high:
            return "bolt"
        }
    }
}

// MARK: - Suggested Type Badge

/// وسم بجانب عنوان «تحدياتك» يوضح نوع التحديات حسب الطاقة.
struct EnergyLevelBadge: View {

    let level: EnergyLevel

    var body: some View {
        HStack(spacing: Spacing.space4) {

            Image(systemName: level.suggestedTypeIcon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(level.color)

            Text(level.suggestedTypeTitle)
                .font(.custom("Alexandria", size: 12).weight(.medium))
                .foregroundStyle(Color.textPrimary)
        }
        .padding(.horizontal, Spacing.space12)
        .frame(height: Spacing.chipHeight)
        .background(level.color.opacity(0.2), in: Capsule())
        .contentTransition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: level)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var energy = 50

    VStack(spacing: Spacing.space24) {
        EnergyCheckInView(energyValue: $energy)

        EnergyLevelBadge(level: EnergyLevel.from(value: energy))
    }
    .padding(Spacing.pageMargin)
    .background(Color.pageBackground)
    .environment(\.layoutDirection, .rightToLeft)
}
