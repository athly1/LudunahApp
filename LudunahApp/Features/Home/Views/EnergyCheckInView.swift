import SwiftUI

struct EnergyCheckInView: View {
    @Binding var energyValue: Int

    private var currentEnergyLevel: EnergyLevel {
        EnergyLevel.from(value: energyValue)
    }

    private var currentEnergyColor: Color {
        switch currentEnergyLevel {
        case .low:
            return Color.artPalette1
        case .medium:
            return Color.artPalette3
        case .high:
            return Color.sportFieldBall
        }
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: Spacing.space8) {

            // عنوان القسم بمحاذاة اليمين
            HStack {
                Spacer(minLength: 0)

                Text("كيف طاقتك اليوم؟")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .environment(\.layoutDirection, .leftToRight)

            // شريط الطاقة بثلاثة مستويات
            GeometryReader { geometry in
                let width = geometry.size.width
                let progress = CGFloat(energyValue) / 100
                let thumbPosition = 16 + progress * (width - 32)

                ZStack(alignment: .leading) {

                    HStack(spacing: 4) {
                        Capsule()
                            .fill(Color.artPalette1)
                            .opacity(
                                currentEnergyLevel == .low ? 1 : 0.4
                            )

                        Capsule()
                            .fill(Color.artPalette3)
                            .opacity(
                                currentEnergyLevel == .medium ? 1 : 0.4
                            )

                        Capsule()
                            .fill(Color.sportFieldBall)
                            .opacity(
                                currentEnergyLevel == .high ? 1 : 0.4
                            )
                    }
                    .frame(height: 16)

                    // مؤشر الطاقة والنسبة المئوية
                    Capsule()
                        .fill(currentEnergyColor)
                        .frame(width: 56, height: 32)
                        .overlay {
                            Text("\(energyValue)%")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color.pageBackground)
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                        }
                        .overlay {
                            Capsule()
                                .stroke(
                                    Color.pageBackground,
                                    lineWidth: 2
                                )
                        }
                        .offset(x: thumbPosition - 28)
                }
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let percentage =
                                value.location.x / width * 100

                            energyValue = min(
                                max(Int(percentage), 0),
                                100
                            )
                        }
                )
            }
            .frame(height: 40)
            .environment(\.layoutDirection, .leftToRight)
        }
    }
}
