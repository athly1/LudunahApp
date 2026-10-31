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

    var energyValue: Int = 50

    private(set) var selectedActivities: [Interest: Activity] = [:]
    private(set) var errorMessage: String?

    var energyLevel: EnergyLevel {
        EnergyLevel.from(value: energyValue)
    }

    // تحميل نشاط مناسب لكل اهتمام مختار
    func loadChallenges(for interests: Set<Interest>) {
        var activities: [Interest: Activity] = [:]
        errorMessage = nil

        for interest in interests {
            do {
                let available = try ContentService
                    .loadActivities(for: interest)
                    .filter { $0.type == energyLevel.activityStep }

                if let selected = available.randomElement() {
                    activities[interest] = selected
                }
            } catch {
                errorMessage = "تعذّر تحميل أنشطة \(interest.title)."
            }
        }

        selectedActivities = activities
    }

    // استرجاع النشاط الحالي لاهتمام معين
    func activity(for interest: Interest) -> Activity? {
        selectedActivities[interest]
    }

    // تبديل النشاط مع الحفاظ على مستوى الطاقة
    @discardableResult
    func swapChallenge(for interest: Interest) -> Bool {
        guard let current = selectedActivities[interest] else {
            return false
        }

        do {
            let alternatives = try ContentService
                .loadActivities(for: interest)
                .filter {
                    $0.type == energyLevel.activityStep &&
                    $0.id != current.id
                }

            guard let next = alternatives.randomElement() else {
                return false
            }

            selectedActivities[interest] = next
            errorMessage = nil
            return true

        } catch {
            errorMessage = "تعذّر تحميل أنشطة \(interest.title)."
            return false
        }
    }
}
