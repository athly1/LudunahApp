// EnergyCheckInView.swift - pick today's energy level.
//
// Contains:
// - A View with one option per EnergyLevel case.
// - Inputs: selected level, action when tapped.
//
// Used by: HomeView.


import SwiftUI

struct EnergyCheckInView: View {
    @Binding var energyValue: Int

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {
            Text("كيف طاقتك اليوم؟")
                .font(.title1Heading)
                .foregroundStyle(Color.textPrimary)

            GeometryReader { geometry in
                let width = geometry.size.width
                let progress = CGFloat(energyValue) / 100
                let thumbPosition = 12 + progress * (width - 24)

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.textPrimary.opacity(0.12))
                        .frame(height: 12)

                    Capsule()
                        .fill(Color.appSecondary)
                        .frame(
                            width: max(12, thumbPosition),
                            height: 12
                        )

                    Circle()
                        .fill(Color.pageBackground)
                        .frame(width: 32, height: 32)
                        .overlay {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Color.appSecondary)
                        }
                        .overlay {
                            Circle()
                                .stroke(
                                    Color.appSecondary,
                                    lineWidth: 2
                                )
                        }
                        .offset(x: thumbPosition - 16)
                }
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let percentage = (
                                value.location.x / width
                            ) * 100

                            energyValue = min(
                                max(Int(percentage), 0),
                                100
                            )
                        }
                )
            }
            .frame(height: 40)
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}
