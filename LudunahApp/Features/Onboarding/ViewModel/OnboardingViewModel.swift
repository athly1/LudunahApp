
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

// MARK: - Onboarding ViewModel

// يدير التنقل والاهتمامات خلال صفحات البداية.
// يحتفظ بالاختيارات حتى عند الرجوع بين الصفحات.
@Observable
final class OnboardingViewModel {

    // MARK: - State

    // الصفحة الحالية: 0 الترحيب، 1 المميزات، 2 الاهتمامات.
    private(set) var currentPage = 0

    // مصفوفة تحفظ الاهتمامات بترتيب اختيار المستخدم.
    private(set) var selectedInterests: [Interest] = []

    // عدد الصفحات وآخر صفحة.
    private let lastPage = 2

    // الحد الأعلى للاهتمامات.
    let maxSelection = 3

    // MARK: - Navigation

    // الانتقال إلى صفحة محددة مع التحقق من رقمها.
    func goToPage(_ page: Int) {
        guard (0...lastPage).contains(page) else { return }
        currentPage = page
    }

    // الانتقال إلى الصفحة التالية.
    func nextPage() {
        goToPage(currentPage + 1)
    }

    // الرجوع إلى الصفحة السابقة.
    func previousPage() {
        goToPage(currentPage - 1)
    }

    // MARK: - Interests

    // اختيار الاهتمام أو إلغاء اختياره.
    func toggleInterest(_ interest: Interest) {
        if let index = selectedInterests.firstIndex(of: interest) {
            selectedInterests.remove(at: index)
        } else {
            // منع اختيار أكثر من ثلاثة اهتمامات.
            guard selectedInterests.count < maxSelection else { return }
            selectedInterests.append(interest)
        }
    }

    // حذف اهتمام من قائمة الاختيارات.
    func removeInterest(_ interest: Interest) {
        selectedInterests.removeAll { $0 == interest }
    }

    // MARK: - Validation

    // لا يسمح بإنهاء البداية إلا من الصفحة الأخيرة
    // وبعد اختيار اهتمام واحد على الأقل.
    var canFinish: Bool {
        currentPage == lastPage && !selectedInterests.isEmpty
    }

    // MARK: - Finish

    // حفظ الاهتمامات وإكمال صفحات البداية.
    func finish(using appState: AppState) {
        guard canFinish else { return }

        appState.updateInterests(Set(selectedInterests))
        appState.completeOnboarding()
    }
}
