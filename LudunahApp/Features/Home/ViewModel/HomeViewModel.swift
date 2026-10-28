// HomeViewModel.swift - logic for the Home screen.
//
// Contains:
// - An @Observable class with: energy level, selected interest for the sheet, weekly progress.
// - Methods: select energy, build today's task, refresh progress.
//
// Used by: HomeView.

import Foundation
import Observation

@Observable
final class HomeViewModel {

    // مستوى الطاقة من 0 إلى 100
    var energyValue: Int = 50

    // ملخص النشاط الذي سيظهر للمستخدم
    private(set) var currentTask: DailyTask?

    // بيانات النشاط الكاملة من JSON
    private(set) var currentActivity: Activity?

    // الاهتمام المرتبط بالنشاط
    private(set) var currentInterest: Interest?

    // عدد الخيارات التي ظهرت
    private(set) var choicesShown: Int = 0

    // رسالة الخطأ إن وجدت
    private(set) var errorMessage: String?

    // الأنشطة البديلة
    private var alternatives: [
        (interest: Interest, activity: Activity)
    ] = []

    // تحويل قيمة الطاقة إلى مستوى
    var energyLevel: EnergyLevel {
        EnergyLevel.from(value: energyValue)
    }

    // نوع النشاط المطلوب حسب الطاقة
    var requiredActivityStep: ActivityStep {
        energyLevel.activityStep
    }

    // MARK: - Energy

    func selectEnergy(value: Int) {
        energyValue = min(max(value, 0), 100)
        resetActivity()
    }

    // MARK: - Build Today's Task

    func buildTodaysTask(using appState: AppState) {

        resetActivity()

        // قراءة الاهتمامات المحفوظة
        let interests = appState.selectedInterests

        guard !interests.isEmpty else {
            errorMessage = "اختار اهتمامًا واحدًا على الأقل."
            return
        }

        do {
            var availableActivities: [
                (interest: Interest, activity: Activity)
            ] = []

            // قراءة أنشطة كل اهتمام مختار
            for interest in Interest.allCases
            where interests.contains(interest) {

                let activities = try ContentService
                    .loadActivities(for: interest)
                    .filter {
                        $0.type == requiredActivityStep
                    }

                for activity in activities {
                    availableActivities.append(
                        (interest: interest, activity: activity)
                    )
                }
            }

            // اختيار نشاط مناسب عشوائيًا
            guard let selected = availableActivities.randomElement()
            else {
                errorMessage =
                    "لم نجد نشاطًا مناسبًا لاختيارك."
                return
            }

            // الاحتفاظ ببيانات النشاط
            currentActivity = selected.activity
            currentInterest = selected.interest

            // إنشاء ملخص النشاط
            currentTask = DailyTask(
                activity: selected.activity,
                interest: selected.interest
            )

            // تجهيز الخيارات البديلة
            alternatives = availableActivities.filter {
                $0.activity.id != selected.activity.id
            }

            choicesShown = 1

        } catch {
            errorMessage =
                "تعذّر تحميل الأنشطة. حاول مرة أخرى."
        }
    }

    // MARK: - Alternative

    func showAlternative() {

        // نعرض خيارين كحد أقصى
        guard choicesShown < 2,
              let next = alternatives.first else {
            return
        }

        currentActivity = next.activity
        currentInterest = next.interest

        currentTask = DailyTask(
            activity: next.activity,
            interest: next.interest
        )

        alternatives.removeFirst()
        choicesShown += 1
    }

    // MARK: - Reset

    private func resetActivity() {
        currentTask = nil
        currentActivity = nil
        currentInterest = nil
        alternatives = []
        choicesShown = 0
        errorMessage = nil
    }
}
