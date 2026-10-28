
// TimerEngine.swift - منطق المؤقت المشترك.
//
// Contains:
// - Start, pause, resume and reset.
// - Update remaining time every second.
// - Publish timer changes to SwiftUI.
// - Swift 6 concurrency-safe timer callback.
//
// Used by: CountdownTimerView, ArtDoView, GamingDoView.

import Foundation
import Combine

// MARK: - Timer Engine

@MainActor
final class TimerEngine: ObservableObject {

    // المدة الأصلية بالثواني
    let duration: Int

    // الوقت المتبقي
    @Published private(set) var remainingTime: Int

    // هل المؤقت يعمل؟
    @Published private(set) var isRunning = false

    // هل انتهى الوقت؟
    @Published private(set) var isFinished = false

    // المؤقت الداخلي
    private var timer: Timer?

    // MARK: - Initialization

    init(duration: Int) {

        let safeDuration = max(0, duration)

        self.duration = safeDuration
        self.remainingTime = safeDuration
        self.isFinished = safeDuration == 0
    }

    // MARK: - Start

    func start() {

        guard !isRunning, !isFinished else {
            return
        }

        guard remainingTime > 0 else {
            finish()
            return
        }

        isRunning = true

        // التقاط self بشكل ضعيف داخل Closure آمنة للتزامن
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in

            // نقل التحديث إلى MainActor
            Task { @MainActor [weak self] in
                self?.tick()
            }
        }
    }

    // MARK: - Pause

    func pause() {

        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    // MARK: - Resume

    func resume() {
        start()
    }

    // MARK: - Reset

    func reset() {

        pause()
        remainingTime = duration
        isFinished = duration == 0
    }

    // MARK: - Tick

    private func tick() {

        guard isRunning else {
            return
        }

        guard remainingTime > 0 else {
            finish()
            return
        }

        remainingTime -= 1

        if remainingTime == 0 {
            finish()
        }
    }

    // MARK: - Finish

    private func finish() {

        pause()
        isFinished = true
    }

    // MARK: - Cleanup

    deinit {
        timer?.invalidate()
    }
}
