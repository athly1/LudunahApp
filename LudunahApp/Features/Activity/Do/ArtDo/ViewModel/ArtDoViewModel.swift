
// ArtDoViewModel.swift - منطق أنشطة تطبيق الفن.
//
// Contains:
// - Random activity selection.
// - Current phase management.
// - Start, next and finish actions.
//
// Used by: ArtDoView.
//
// Learn: @Observable, randomElement,
//        computed properties and functions.

import Foundation
import Observation

// MARK: - Art Do Stage

enum ArtDoStage {

    // قبل البدء
    case ready

    // أثناء التنفيذ
    case running

    // النشاط مكتمل
    case completed
}

// MARK: - Art Do ViewModel

@MainActor
@Observable
final class ArtDoViewModel {

    // MARK: - Properties

    // النشاط المختار عشوائيًا
    private(set) var activity: ArtDoModel?

    // حالة النشاط
    private(set) var stage: ArtDoStage = .ready

    // رقم المرحلة الحالية يبدأ من صفر
    private(set) var phaseIndex = 0

    // رسالة الخطأ
    private(set) var errorMessage: String?

    // MARK: - Initialization

    init() {
        loadActivity()
    }

    // MARK: - Load Activity

    private func loadActivity() {

        do {

            // قراءة أنشطة Art Do من Art.json
            let activities = try ArtDoLoader.loadActivities()

            // اختيار نشاط عشوائي مثل Art Learn
            guard let selectedActivity =
                activities.randomElement() else {

                errorMessage = "لا توجد أنشطة تطبيق متاحة."
                return
            }

            // تخزين النشاط المختار
            activity = selectedActivity

        } catch {

            errorMessage = "تعذر تحميل أنشطة الفن."
            print("Art Do loading error: \(error)")
        }
    }

    // MARK: - Computed Properties

    // عدد مراحل النشاط
    var totalPhases: Int {
        activity?.phases.count ?? 0
    }

    // المرحلة الحالية
    var currentPhase: ArtDoPhase? {

        guard let activity,
              activity.phases.indices.contains(phaseIndex) else {
            return nil
        }

        return activity.phases[phaseIndex]
    }

    // رقم المرحلة الظاهر للمستخدم
    var currentPhaseNumber: Int {
        phaseIndex + 1
    }

    // هل المرحلة الأخيرة؟
    var isLastPhase: Bool {

        guard totalPhases > 0 else {
            return false
        }

        return phaseIndex == totalPhases - 1
    }

    // هل يسمح النشاط بإيقاف المؤقت في هذه المرحلة؟
    var canPauseCurrentPhase: Bool {
        currentPhase?.allowPause ?? false
    }

    // MARK: - Start Activity

    func startActivity() {

        guard stage == .ready,
              currentPhase != nil else {
            return
        }

        stage = .running
    }

    // MARK: - Next Phase

    func nextPhase() {

        guard stage == .running,
              !isLastPhase else {
            return
        }

        phaseIndex += 1
    }

    // MARK: - Finish Activity

    func finishActivity() {

        guard stage == .running,
              isLastPhase else {
            return
        }

        stage = .completed
    }
}
