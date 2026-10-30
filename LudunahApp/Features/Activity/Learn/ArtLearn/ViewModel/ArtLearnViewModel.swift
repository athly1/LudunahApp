
// ArtLearnViewModel.swift - منطق بطاقات تعلّم الفن.
//
// Contains:
// - Load an Art Learn activity by ID.
// - Random activity selection for Preview.
// - Store activity title, image and insight.
// - Manage card index and progress.
// - Navigate between learning cards.
//
// Used by: ArtLearnView.
//
// Learn: ObservableObject, @Published,
//        init, randomElement, do-catch.

import Foundation
import Combine

// MARK: - Art Learn ViewModel

final class ArtLearnViewModel: ObservableObject {

    // MARK: - Properties

    // رقم البطاقة الحالية
    @Published var index = 0

    // بطاقات النشاط
    @Published var cards: [ActivityCard] = []

    // عنوان النشاط
    @Published var title = ""

    // صورة النشاط
    @Published var imageName: String?

    // خلاصة التعلم
    @Published var insight: String?

    // رسالة الخطأ
    @Published var errorMessage: String?

    // MARK: - Initialization

    init(activityID: String? = nil) {
        loadActivity(activityID: activityID)
    }

    // MARK: - Load Activity

    private func loadActivity(activityID: String?) {

        do {
            // تحميل أنشطة Learn من Art.json
            let activities = try ArtLearnLoader.loadActivities()

            // طباعة المعرّف المطلوب
            print(
                "REQUESTED ART LEARN ID:",
                activityID ?? "nil"
            )

            // طباعة الأنشطة المتاحة
            for item in activities {
                print("AVAILABLE:", item.id, item.title)
            }

            // تحديد النشاط المطلوب
            let selectedActivity: ArtLearnModel?

            if let activityID {

                // فتح النشاط المحدد من الرئيسية
                selectedActivity = activities.first {
                    $0.id == activityID
                }

            } else {

                // اختيار عشوائي للمعاينة
                selectedActivity = activities.randomElement()
            }

            guard let activity = selectedActivity else {
                errorMessage = "تعذر العثور على نشاط التعلم المطلوب."
                return
            }

            // تخزين بيانات النشاط
            title = activity.title
            cards = activity.cards
            imageName = activity.image
            insight = activity.insight

            // البدء من أول بطاقة
            index = 0

            // إزالة رسالة الخطأ
            errorMessage = nil

        } catch {

            print("Art Learn loading error: \(error)")
            errorMessage = "تعذر تحميل أنشطة التعلم."
        }
    }

    // MARK: - Card Progress

    var totalCards: Int {
        cards.count
    }

    var currentProgress: Double {

        guard totalCards > 0 else {
            return 0
        }

        return Double(index + 1)
    }

    var isLastCard: Bool {
        !cards.isEmpty && index == cards.count - 1
    }

    // MARK: - Next Card

    func nextCard() {

        guard index < cards.count - 1 else {
            return
        }

        index += 1
    }

    // MARK: - Previous Card

    func previousCard() {

        guard index > 0 else {
            return
        }

        index -= 1
    }
}
