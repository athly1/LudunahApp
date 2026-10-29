
// InstructionsSheetViewModel.swift - بيانات نافذة تعليمات التحدي.
//
// Contains:
// - Load the selected activity.
// - Display title, description and skills.
// - Format duration using English digits.
// - Display activity type and interest information.
//
// Used by: InstructionsSheet.
//
// Learn: ObservableObject, @Published,
//        init, do-catch, String.

import Foundation
import Combine
import SwiftUI

// MARK: - Instructions Sheet ViewModel

final class InstructionsSheetViewModel: ObservableObject {

    // MARK: - Activity Information

    @Published var title = ""
    @Published var description = ""
    @Published var skills: [String] = []
    @Published var duration = ""
    @Published var typeTitle = ""

    // MARK: - Interest Information

    @Published var interestTitle = ""
    @Published var interestColor: Color = .clear
    @Published var imageName = ""
    @Published var infoIcon = "info.circle"

    // MARK: - Selected Activity

    let interest: Interest

    @Published var activity: Activity?

    // MARK: - Initialization

    init(
        interest: Interest,
        activity preselected: Activity? = nil
    ) {

        self.interest = interest

        do {

            // تحميل الأنشطة من JSON
            let activities = try ContentService.loadActivities(
                for: interest
            )

            // استخدام نشاط Home المختار إن وجد
            guard let selectedActivity =
                preselected ?? activities.randomElement() else {

                print("No activities found.")
                return
            }

            // حفظ النشاط للتنقل
            self.activity = selectedActivity

            // MARK: - Activity Details

            title = selectedActivity.title

            description = selectedActivity.summary ?? ""

            skills = selectedActivity.skills ?? []

            // MARK: - Duration

            if let minutes = selectedActivity.durationMin,
               minutes > 0 {

                duration = String(minutes) + " دقائق"

            } else {

                duration = "المدة غير محددة"
            }

            // MARK: - Activity Type

            switch selectedActivity.type {

            case .learn:
                typeTitle = "تعلّم"

            case .doActivity:
                typeTitle = "تحدٍّ"

            case .create:
                typeTitle = "ابتكر"
            }

            // MARK: - Interest Information

            switch interest {

            case .art:
                interestTitle = "الفن"
                interestColor = .artChipBackground
                imageName = "paintpalette"

            case .gaming:
                interestTitle = "الألعاب الإلكترونية"
                interestColor = .gamingChip
                imageName = "gamecontroller"

            case .sport:
                interestTitle = "الرياضة"
                interestColor = .sportChip
                imageName = "figure.run"
            }

        } catch {

            print("Failed to load activities: \(error)")
        }
    }
}
