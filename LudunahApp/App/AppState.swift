
// AppState.swift - إدارة حالة التطبيق واهتمامات المستخدم.
//
// Contains:
// - An @Observable class for application state.
// - Tracks onboarding completion and selected interests.
// - Loads and saves values through StorageService.
// - Methods to complete onboarding, update interests, and reset.
//
// Used by: LudoonaApp, OnboardingViewModel, HomeViewModel, SettingsView.
// Learn: @Observable, @Environment, init, Set, dependency injection.

import Foundation
import Observation // يوفر @Observable لمتابعة تغيّر البيانات

// يجعل SwiftUI قادرة على متابعة حالة التطبيق
@Observable
final class AppState {

    // هل المستخدم أكمل صفحات البداية؟
    private(set) var isOnboardingCompleted: Bool

    // الاهتمامات التي اختارها المستخدم
    private(set) var selectedInterests: Set<Interest>

    // خدمة التخزين التي سنستخدمها للحفظ والقراءة
    private let storage: StorageService

    // تجهيز حالة التطبيق عند إنشائها
    init(storage: StorageService = StorageService()) {

        // الاحتفاظ بخدمة التخزين لاستخدامها لاحقًا
        self.storage = storage

        // قراءة حالة صفحات البداية من التخزين
        self.isOnboardingCompleted = storage.loadOnboardingCompleted()

        // قراءة اهتمامات المستخدم المحفوظة
        self.selectedInterests = storage.loadSelectedInterests()
    }

    // MARK: - Onboarding

    // إنهاء صفحات البداية وحفظ الحالة
    func completeOnboarding() {

        // تحديث الحالة داخل التطبيق
        isOnboardingCompleted = true

        // حفظ الحالة لاستخدامها عند فتح التطبيق لاحقًا
        storage.saveOnboardingCompleted(true)
    }

    // MARK: - Interests

    // تحديث الاهتمامات التي اختارها المستخدم
    func updateInterests(_ interests: Set<Interest>) {

        // تحديث الاهتمامات في حالة التطبيق
        selectedInterests = interests

        // حفظ الاهتمامات الجديدة على الجهاز
        storage.saveSelectedInterests(interests)
    }

    // MARK: - Reset

    // إعادة التطبيق لحالة البداية
    func reset() {

        // حذف البيانات المحفوظة التي يديرها StorageService
        storage.resetEverything()

        // إعادة حالة صفحات البداية إلى غير مكتملة
        isOnboardingCompleted = false

        // إزالة جميع الاهتمامات المحددة
        selectedInterests = []
    }
}
