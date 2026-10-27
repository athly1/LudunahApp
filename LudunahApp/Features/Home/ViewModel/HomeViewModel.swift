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

    // MARK: - User Selections

    var energyValue: Int = 50
    var selectedInterests: Set<Interest> = []

    // MARK: - Current Activity

    private(set) var currentActivity: Activity?
    private(set) var currentInterest: Interest?
    private(set) var choicesShown: Int = 0
    private(set) var errorMessage: String?

    // الأنشطة المتاحة للاهتمام والنوع الحاليين
    private var alternatives: [Activity] = []

    // MARK: - Energy

    var energyLevel: EnergyLevel {
        EnergyLevel.from(value: energyValue)
    }

    var requiredActivityStep: ActivityStep {
        energyLevel.activityStep
    }

    func selectEnergy(value: Int) {
        energyValue = min(max(value, 0), 100)
        resetActivity()
    }

    // MARK: - Build Today's Task

    func buildTodaysTask() {
        resetActivity()
        errorMessage = nil

        guard !selectedInterests.isEmpty else {
            errorMessage = "اختاري اهتمامًا واحدًا على الأقل."
            return
        }

        do {
            // تحميل الأنشطة من الاهتمامات المختارة فقط
            var availableActivities: [
                (interest: Interest, activities: [Activity])
            ] = []

            for interest in Interest.allCases
            where selectedInterests.contains(interest) {

                let activities = try ContentService
                    .loadActivities(for: interest)
                    .filter { $0.type == requiredActivityStep }

                if !activities.isEmpty {
                    availableActivities.append(
                        (interest: interest, activities: activities)
                    )
                }
            }

            guard let selection = availableActivities.randomElement(),
                  let firstActivity = selection.activities.randomElement()
            else {
                errorMessage = "لم نجد نشاطًا مناسبًا للاختيارات الحالية."
                return
            }

            // الاحتفاظ بالبدائل من الاهتمام والنوع نفسيهما
            currentInterest = selection.interest
            currentActivity = firstActivity

            alternatives = selection.activities.filter {
                $0.id != firstActivity.id
            }

            choicesShown = 1

        } catch {
            errorMessage = "تعذّر تحميل الأنشطة. حاولي مرة أخرى."
        }
    }

    // MARK: - Alternative Activity

    func showAlternative() {
        guard choicesShown < 2,
              let nextActivity = alternatives.first
        else {
            return
        }

        currentActivity = nextActivity
        alternatives.removeFirst()
        choicesShown += 1
    }

    // MARK: - Reset

    private func resetActivity() {
        currentActivity = nil
        currentInterest = nil
        alternatives = []
        choicesShown = 0
        errorMessage = nil
    }
}
