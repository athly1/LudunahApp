import SwiftUI

// Shows the steps in a Do activity.
struct DoStepsCard: View {

    // Steps supplied by the ViewModel.
    let howTo: [String]

    // Color of the step number circles.
    let stepRingColor: Color

    var body: some View {

        VStack(spacing: Spacing.space12) {

            // Loop through every step.
            ForEach(Array(howTo.enumerated()), id: \.offset) { index, step in

                HStack(alignment: .center, spacing: 8) {

                    // MARK: - Number Circle
                    ZStack {
                        Circle()
                            .stroke(stepRingColor, lineWidth: 2)
                            .frame(width: 24, height: 24)

                        Text("\(index + 1)")
                            .font(.titleCards)
                            .foregroundStyle(stepRingColor)
                    }

                    // MARK: - Step Instruction
                    Text(step)
                        .font(.titleCards)
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // MARK: - Subtle Divider
                                if index < howTo.count - 1 {
                                    Rectangle()
                                        .fill(Color.textPrimary.opacity(0.11))
                                        .frame(height: 1)
                                        .padding(.leading, 8)
                                }
                
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, Spacing.pageMargin)
        .padding(.bottom, Spacing.pageMargin)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 8)
    }
}

#Preview {
    DoStepsCard(
        howTo: [
            "اخفِ الخريطة المصغّرة من إعدادات اللعبة",
            "استكشف منطقة ما زرتها قبل",
            "ارجع لنقطة البداية بالاعتماد على المعالم بس"
        ],
        stepRingColor: Color.mapSequers
    )
    .environment(\.locale, Locale(identifier: "ar"))
    .environment(\.layoutDirection, .rightToLeft)
}
