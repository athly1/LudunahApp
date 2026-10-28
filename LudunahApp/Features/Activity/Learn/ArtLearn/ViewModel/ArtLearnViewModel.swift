
// ArtLearnViewModel.swift - منطق بطاقات تعلّم الفن.
//
// Contains:
// - Load an Art Learn activity.
// - Store the activity image name.
// - Manage current card index.
// - Calculate progress.
// - Move between cards.
//
// Used by: ArtLearnView.
// Learn: ObservableObject, @Published,
//       randomElement, computed properties.

import Foundation
import Combine

// MARK: - Art Learn ViewModel

final class ArtLearnViewModel: ObservableObject {

    // رقم البطاقة الحالية
    @Published var index = 0

    // البطاقات الخاصة بالنشاط
    @Published var cards: [ActivityCard] = []

    // عنوان النشاط
    @Published var title = ""

    // اسم صورة النشاط
    @Published var imageName: String?

    // ملخص النشاط
    @Published var insight: String?

    // رسالة خطأ إذا فشل التحميل
    @Published var errorMessage: String?

    // MARK: - Initialization

    init() {
        loadActivity()
    }

    // MARK: - Load Activity

    private func loadActivity() {

        do {

            // قراءة جميع أنشطة Art Learn
            let activities = try ArtLearnLoader.loadActivities()

            // اختيار نشاط تعلم عشوائي
            guard let activity = activities.randomElement() else {

                errorMessage = "لا توجد أنشطة تعلم متاحة."
                return
            }
            
            
           // guard let activity = activities.first(where: {
              //  $0.id == "art-learn-1"
           // }) else {
             //   errorMessage = "لم يتم العثور على نشاط الفسيفساء."
             //   return
          //  }

            
            

            // تخزين بيانات النشاط المختار
            title = activity.title
            cards = activity.cards
            imageName = activity.image
            insight = activity.insight

            // بدء العرض من أول بطاقة
            index = 0

        } catch {

            print("Failed to load Art Learn: \(error)")

            errorMessage = "تعذر تحميل نشاط تعلّم الفن."
        }
    }

    // MARK: - Card Progress

    // العدد الكلي للبطاقات
    var totalCards: Int {
        cards.count
    }

    // التقدم الحالي
    var currentProgress: Double {

        guard totalCards > 0 else {
            return 0
        }

        return Double(index + 1)
    }

    // هل هذه آخر بطاقة؟
    var isLastCard: Bool {

        !cards.isEmpty &&
        index == cards.count - 1
    }

    // MARK: - Next Card

    // الانتقال إلى البطاقة التالية
    func nextCard() {

        guard index < cards.count - 1 else {
            return
        }

        index += 1
    }

    // MARK: - Previous Card

    // الرجوع إلى البطاقة السابقة
    func previousCard() {

        guard index > 0 else {
            return
        }

        index -= 1
    }
}
