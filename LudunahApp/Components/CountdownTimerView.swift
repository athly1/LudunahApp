
import SwiftUI

struct CountdownTimerView: View {

    // MARK: - Properties

    @ObservedObject var engine: TimerEngine

    var color: Color = .artTimerRing
    var size: CGFloat = 145

    // MARK: - Formatted Time

    private var formattedTime: String {
        let minutes = engine.remainingTime / 60
        let seconds = engine.remainingTime % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    // MARK: - Progress

    private var progress: CGFloat {
        guard engine.duration > 0 else { return 0 }

        return CGFloat(engine.remainingTime)
            / CGFloat(engine.duration)
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {

            ZStack {
                Circle()
                    .fill(Color.white)

                Circle()
                    .stroke(
                        color.opacity(0.18),
                        lineWidth: 4
                    )

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        color,
                        style: StrokeStyle(
                            lineWidth: 6,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: 8,
                        x: 2,
                        y: 8
                    )

                if engine.isFinished {
                    Text("انتهى الوقت")
                        .font(.custom("thmanyah sans", size: 20).weight(.bold))
                        .foregroundStyle(color)
                        .multilineTextAlignment(.center)
                } else {
                    Text(formattedTime)
                        .font(.custom("thmanyah sans", size: 34).weight(.bold))
                        .monospacedDigit()
                        .foregroundStyle(Color.textPrimary)
                }
                
            }
            .frame(width: size, height: size)

            HStack(spacing: 20) {
                Button("ابدأ") {
                    engine.start()
                }
                .disabled(engine.isRunning || engine.isFinished)

                Button("إيقاف") {
                    engine.pause()
                }
                .disabled(!engine.isRunning)

                Button("إعادة") {
                    engine.reset()
                }
            }
            .font(.system(size: 14, weight: .medium))
            .tint(color)

            if engine.isFinished {
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
        color: .artTimerRing
    )
    .padding(Spacing.space24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.pageBackground)
}

