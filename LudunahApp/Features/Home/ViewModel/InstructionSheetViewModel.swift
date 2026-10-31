
//
// InstructionSheetViewModel.swift
// مسؤول عن تجهيز بيانات النشاط المعروضة في نافذة التعليمات.
//
// Contains:
// - استقبال النشاط المختار من HomeView.
// - تحميل نشاط من JSON عند عدم تمرير نشاط.
// - تجهيز العنوان والوصف والمهارات والمدة.
// - تحديد نوع النشاط والاهتمام المرتبط به.
//
// Used by: InstructionsSheet.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Instructions Sheet ViewModel

final class InstructionsSheetViewModel: ObservableObject {

    // MARK: - Activity Information

    // عنوان النشاط الذي سيظهر في نافذة التعليمات.
    @Published var title = ""

    // وصف النشاط القادم من JSON.
    @Published var description = ""

    // المهارات المرتبطة بالنشاط.
    @Published var skills: [String] = []

    // المدة التي تظهر للمستخدم بصيغة نصية.
    @Published var duration = ""

    // نوع النشاط: تعلّم، تحدٍّ، أو ابتكر.
    @Published var typeTitle = ""

    // MARK: - Interest Information

    // اسم الاهتمام الذي ينتمي إليه النشاط.
    @Published var interestTitle = ""

    // لون الشارة الخاصة بالاهتمام.
    @Published var interestColor: Color = .clear

    // اسم الرمز المرتبط بالاهتمام.
    @Published var imageName = ""

    // رمز بطاقة معلومات النشاط.
    @Published var infoIcon = "info.circle"

    // MARK: - Selected Activity

    // الاهتمام الذي اختاره المستخدم.
    let interest: Interest

    // النشاط الفعلي المستخدم في نافذة التعليمات.
    // يُستخدم أيضًا لتحديد الشاشة التي ستُفتح عند بدء التحدي.
    @Published var activity: Activity?

    // MARK: - Initialization

    init(
        interest: Interest,
        activity preselected: Activity? = nil
    ) {
        self.interest = interest

        // نجهز بيانات الاهتمام بشكل مستقل عن تحميل النشاط.
        // حتى لا تبقى بيانات الاهتمام فارغة إذا فشل تحميل JSON.
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

        do {
            // MARK: - Select Activity

            let selectedActivity: Activity

            if let preselected {
                // إذا وصلنا نشاط من HomeView نستخدمه مباشرة.
                // لا نعيد قراءة JSON ولا نختار نشاطًا آخر.
                selectedActivity = preselected

            } else {
                // مسار احتياطي: عند فتح InstructionsSheet
                // دون تمرير نشاط، نحمّل أنشطة الاهتمام من JSON.
                let activities = try ContentService.loadActivities(
                    for: interest
                )

                // نختار نشاطًا عشوائيًا فقط في المسار الاحتياطي.
                guard let randomActivity = activities.randomElement() else {
                    print("No activities found for \(interest.rawValue).")
                    return
                }

                selectedActivity = randomActivity
            }

            // نحفظ النشاط نفسه لاستخدامه عند بدء التحدي.
            self.activity = selectedActivity

            // MARK: - Activity Details

            // نعرض بيانات النشاط الذي تم اختياره فعلًا.
            title = selectedActivity.title
            description = selectedActivity.summary ?? ""
            skills = selectedActivity.skills ?? []

            // MARK: - Duration

            // نعتمد على مدة النشاط من JSON بدل رقم ثابت.
            if let minutes = selectedActivity.durationMin,
               minutes > 0 {
                duration = "\(minutes) دقائق"
            } else {
                duration = "المدة غير محددة"
            }

            // MARK: - Activity Type

            // نحدد اسم نوع النشاط المعروض في البطاقة.
            switch selectedActivity.type {

            case .learn:
                typeTitle = "تعلّم"

            case .doActivity:
                typeTitle = "تحدٍّ"

            case .create:
                typeTitle = "ابتكر"
            }

        } catch {
            // إذا فشل تحميل JSON نترك activity بقيمة nil.
            // يجب على InstructionsSheet منع بدء نشاط غير موجود.
            print("Failed to load activities: \(error)")
        }
    }
}
