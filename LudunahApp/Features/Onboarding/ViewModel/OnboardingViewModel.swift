
// OnboardingViewModel.swift - منطق صفحات البداية.
//
// Contains:
// - Current page and selected interests.
// - Next, previous and direct page navigation.
// - Interest selection.
// - Validation and onboarding completion.
//
// Used by: OnboardingView.
// Learn: @Observable, Set, guard, computed properties.

import Foundation
import Observation

// منطق صفحات البداية
@Observable
final class OnboardingViewModel {

    // رقم الصفحة الحالية
    private(set) var currentPage: Int = 0

    // الاهتمامات المختارة
    private(set) var selectedInterests: Set<Interest> = []

    // آخر صفحة هي صفحة الاهتمامات
    private let lastPage: Int = 2

    // MARK: - Navigation

    // الانتقال للصفحة التالية
    func nextPage() {

        guard currentPage < lastPage else {
            return
        }

        currentPage += 1
    }

    // الرجوع للصفحة السابقة
    func previousPage() {

        guard currentPage > 0 else {
            return
        }

        currentPage -= 1
    }

    // الانتقال لصفحة محددة عند السحب
    func goToPage(_ page: Int) {

        // التأكد أن الصفحة ضمن الصفحات المتاحة
        guard (0...lastPage).contains(page) else {
            return
        }

        currentPage = page
    }

    // MARK: - Interests

    // تحديد اهتمام أو إلغاء تحديده
    func toggleInterest(_ interest: Interest) {

        // هل الاهتمام محدد من قبل؟
        if selectedInterests.contains(interest) {

            // إلغاء الاختيار
            selectedInterests.remove(interest)

        } else {

            // إضافة الاهتمام
            selectedInterests.insert(interest)
        }
    }

    // MARK: - Validation

    // هل يمكن إنهاء صفحات البداية؟
    var canFinish: Bool {

        // آخر صفحة واهتمام واحد على الأقل
        currentPage == lastPage && !selectedInterests.isEmpty
    }

    // MARK: - Finish

    // إنهاء البداية وحفظ الاهتمامات
    func finish(using appState: AppState) {

        // منع الإنهاء إذا الشروط غير متحققة
        guard canFinish else {
            return
        }

        // تحديث الاهتمامات وحفظها
        appState.updateInterests(selectedInterests)

        // إكمال البداية
        appState.completeOnboarding()
    }
}
