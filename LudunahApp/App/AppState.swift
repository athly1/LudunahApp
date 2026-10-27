
// AppState.swift - حالة التطبيق واهتمامات المستخدم.
//
// Contains:
// - Observable application state.
// - Onboarding completion status.
// - Selected interests.
// - Save and load through StorageService.
//
// Used by: LudoonaApp, OnboardingViewModel,
// HomeViewModel, SettingsView.
// Learn: @Observable, init, private(set).

import Foundation
import Observation

// حالة التطبيق القابلة للملاحظة
@Observable
final class AppState {

    // هل المستخدم أكمل البداية؟
    private(set) var isOnboardingCompleted: Bool

    // الاهتمامات المختارة
    private(set) var selectedInterests: Set<Interest>

    // خدمة التخزين
    private let storage: StorageService

    // تجهيز حالة التطبيق
    init(storage: StorageService = StorageService()) {

        // الاحتفاظ بخدمة التخزين
        self.storage = storage

        // قراءة حالة البداية المحفوظة
        self.isOnboardingCompleted = storage.loadOnboardingCompleted()

        // قراءة الاهتمامات المحفوظة
        self.selectedInterests = storage.loadSelectedInterests()
    }

    // MARK: - Onboarding

    // إكمال صفحات البداية
    func completeOnboarding() {

        // تحديث الحالة
        isOnboardingCompleted = true

        // حفظ الحالة
        storage.saveOnboardingCompleted(true)
    }

    // MARK: - Interests

    // تحديث الاهتمامات
    func updateInterests(_ interests: Set<Interest>) {

        // تحديث الاختيارات الحالية
        selectedInterests = interests

        // حفظ الاختيارات
        storage.saveSelectedInterests(interests)
    }

    // MARK: - Reset

    // إعادة التطبيق لحالة البداية
    func reset() {

        // حذف البيانات المحفوظة
        storage.resetEverything()

        // إعادة حالة البداية
        isOnboardingCompleted = false

        // إلغاء اختيار جميع الاهتمامات
        selectedInterests = []
    }
}
