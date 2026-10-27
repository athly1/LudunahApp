
// ArtDoViewModel.swift - منطق نشاط الفن Do.
//
// Contains:
// - Collecting and reflection stages.
// - Five-minute countdown.
// - Ten-second reflection countdown.
// - Automatic completion after reflection.
//
// Used by: ArtDoView.
// Learn: @Observable, enum, Task, Date,
//       functions, computed properties.

import Foundation
import Observation

// MARK: - Activity Stage

// الحالات التي يمر بها النشاط
enum ArtDoStage {

    // قبل بدء النشاط
    case ready

    // جمع العناصر وترتيبها
    case collecting

    // التأمل لمدة 10 ثوانٍ
    case reflecting

    // انتهى النشاط
    case completed
}

// MARK: - ViewModel

@MainActor
@Observable
final class ArtDoViewModel {

    // MARK: - Properties

    // بيانات نشاط غروب الشمس
    let activity = ArtDoModel.sunset

    // الحالة الحالية
    private(set) var stage: ArtDoStage = .ready

    // الوقت المتبقي
    private(set) var remainingSeconds: Int = 300

    // هل المؤقت يعمل؟
    private(set) var isRunning = false

    // المهمة المسؤولة عن المؤقت
    @ObservationIgnored
    private var timerTask: Task<Void, Never>?

    // وقت انتهاء العد الحالي
    @ObservationIgnored
    private var endDate: Date?

    // MARK: - Computed Properties

    // هل وصلنا لشاشة التأمل؟
    var isReflecting: Bool {
        stage == .reflecting
    }

    // هل انتهى النشاط؟
    var isCompleted: Bool {
        stage == .completed
    }

    // تنسيق الوقت 05:00 أو 00:10
    var formattedTime: String {

        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60

        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }

    // نسبة تقدم المؤقت الحالي
    var progress: Double {

        let duration: Int

        if stage == .reflecting {
            duration = activity.reflectionDuration
        } else {
            duration = activity.activityDuration
        }

        guard duration > 0 else {
            return 1
        }

        return Double(duration - remainingSeconds)
            / Double(duration)
    }

    // MARK: - Start Activity

    // يبدأ المستخدم جمع العناصر
    func startActivity() {

        guard stage == .ready else {
            return
        }

        stage = .collecting

        remainingSeconds = activity.activityDuration

        startTimer()
    }

    // MARK: - Start Reflection

    // عندما يضغط المستخدم زر أنهيت
    func startReflection() {

        guard stage == .collecting else {
            return
        }

        // إلغاء مؤقت الخمس دقائق
        stopTimer()

        // الانتقال إلى شاشة التأمل
        stage = .reflecting

        // المؤقت الجديد 10 ثوانٍ
        remainingSeconds = activity.reflectionDuration

        // تشغيل المؤقت الجديد
        startTimer()
    }

    // MARK: - Start Timer

    private func startTimer() {

        guard !isRunning else {
            return
        }

        isRunning = true

        // تحديد وقت انتهاء المؤقت
        endDate = Date().addingTimeInterval(
            TimeInterval(remainingSeconds)
        )

        // إنشاء مهمة تحدث المؤقت
        timerTask = Task {

            while !Task.isCancelled && isRunning {

                do {
                    try await Task.sleep(
                        for: .milliseconds(100)
                    )
                } catch {
                    return
                }

                // تحديث الوقت
                updateTimer()
            }
        }
    }

    // MARK: - Update Timer

    private func updateTimer() {

        guard let endDate else {
            return
        }

        let secondsLeft = endDate.timeIntervalSinceNow

        // إذا انتهى المؤقت
        if secondsLeft <= 0 {

            remainingSeconds = 0

            stopTimer()

            // الانتقال إلى Home بعد التأمل فقط
            if stage == .reflecting {
                stage = .completed
            }

            // إذا انتهت الخمس دقائق،
            // نبقى على شاشة النشاط حتى يضغط أنهيت
            return
        }

        // حساب الوقت المتبقي
        remainingSeconds = Int(ceil(secondsLeft))
    }

    // MARK: - Pause

    func pause() {

        guard isRunning else {
            return
        }

        // حفظ الوقت المتبقي
        if let endDate {
            remainingSeconds = max(
                0,
                Int(ceil(endDate.timeIntervalSinceNow))
            )
        }

        stopTimer()
    }

    // MARK: - Resume

    func resume() {

        guard !isRunning else {
            return
        }

        guard stage == .collecting ||
              stage == .reflecting else {
            return
        }

        guard remainingSeconds > 0 else {
            return
        }

        startTimer()
    }

    // MARK: - Stop Timer

    private func stopTimer() {

        isRunning = false

        timerTask?.cancel()
        timerTask = nil

        endDate = nil
    }
}
