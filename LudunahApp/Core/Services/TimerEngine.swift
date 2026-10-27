import Foundation
import Combine

@MainActor
final class TimerEngine: ObservableObject {

    let duration: Int

    @Published private(set) var remainingTime: Int
    @Published private(set) var isRunning = false
    @Published private(set) var isFinished = false

    private var timer: Timer?

    init(duration: Int) {
        let safeDuration = max(0, duration)

        self.duration = safeDuration
        self.remainingTime = safeDuration
        self.isFinished = safeDuration == 0
    }

    func start() {
        guard !isRunning, !isFinished else { return }

        guard remainingTime > 0 else {
            finish()
            return
        }

        isRunning = true

        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func resume() {
        start()
    }

    func reset() {
        pause()
        remainingTime = duration
        isFinished = duration == 0
    }

    private func tick() {
        guard remainingTime > 0 else {
            finish()
            return
        }

        remainingTime -= 1

        if remainingTime == 0 {
            finish()
        }
    }

    private func finish() {
        pause()
        isFinished = true
    }

    deinit {
        timer?.invalidate()
    }
}
