
// StorageService.swift - التخزين المحلي والتقدم الأسبوعي.
//
// Contains:
// - Save and load onboarding status.
// - Save and load selected interests.
// - Record completed activities.
// - Calculate last 7 days progress.
// - Reset progress or all app data.
//
// Used by: AppState, HomeViewModel.
// Learn: UserDefaults, JSONEncoder, JSONDecoder, Calendar.

import Foundation

// خدمة حفظ بيانات التطبيق
final class StorageService {

    // التخزين المحلي
    private let defaults = UserDefaults.standard

    // مفاتيح تخزين البيانات
    private enum Keys {
        static let onboardingCompleted = "onboardingCompleted"
        static let selectedInterests = "selectedInterests"
        static let activityProgress = "activityProgress"
        static let sportCreatePlans = "sportCreatePlans"
    }

    // MARK: - Onboarding

    // حفظ حالة إكمال صفحات البداية
    func saveOnboardingCompleted(_ completed: Bool) {
        defaults.set(completed, forKey: Keys.onboardingCompleted)
    }

    // قراءة حالة إكمال البداية
    func loadOnboardingCompleted() -> Bool {
        return defaults.bool(forKey: Keys.onboardingCompleted)
    }

    // MARK: - Interests

    // حفظ الاهتمامات
    func saveSelectedInterests(_ interests: Set<Interest>) {

        // تحويل الاهتمامات إلى JSON Data
        guard let data = try? JSONEncoder().encode(interests) else {
            return
        }

        // حفظ البيانات محليًا
        defaults.set(data, forKey: Keys.selectedInterests)
    }

    // استرجاع الاهتمامات
    func loadSelectedInterests() -> Set<Interest> {

        // قراءة البيانات المحفوظة
        guard let data = defaults.data(forKey: Keys.selectedInterests) else {
            return []
        }

        // تحويل البيانات إلى Set من الاهتمامات
        return (try? JSONDecoder().decode(
            Set<Interest>.self,
            from: data
        )) ?? []
    }

    // MARK: - Sport Create Plans

    // حفظ خطة رياضة جديدة
    func saveSportCreatePlan(_ plan: SportCreateModel) {
        var plans = loadSportCreatePlans()
        plans.append(plan)

        guard let data = try? JSONEncoder().encode(plans) else {
            return
        }

        defaults.set(data, forKey: Keys.sportCreatePlans)
    }

    // قراءة الخطط المحفوظة
    func loadSportCreatePlans() -> [SportCreateModel] {
        guard let data = defaults.data(forKey: Keys.sportCreatePlans) else {
            return []
        }

        return (try? JSONDecoder().decode(
            [SportCreateModel].self,
            from: data
        )) ?? []
    }
    
    
    // MARK: - Activity Progress

    // تسجيل نشاط مكتمل
    func recordCompletedActivity(interest: Interest) {

        // قراءة الإنجازات السابقة
        var progress = loadActivityProgress()

        // إنشاء سجل إنجاز جديد
        let newRecord = ActivityProgress(interest: interest)

        // إضافة السجل للقائمة
        progress.append(newRecord)

        // حفظ القائمة بعد التحديث
        saveActivityProgress(progress)
    }

    // حفظ قائمة الإنجازات
    private func saveActivityProgress(_ progress: [ActivityProgress]) {

        // تحويل القائمة إلى JSON Data
        guard let data = try? JSONEncoder().encode(progress) else {
            return
        }

        // تخزين البيانات
        defaults.set(data, forKey: Keys.activityProgress)
    }

    // استرجاع الإنجازات
    func loadActivityProgress() -> [ActivityProgress] {

        // البحث عن البيانات المحفوظة
        guard let data = defaults.data(forKey: Keys.activityProgress) else {
            return []
        }

        // تحويل البيانات إلى سجلات إنجاز
        return (try? JSONDecoder().decode(
            [ActivityProgress].self,
            from: data
        )) ?? []
    }

    // MARK: - Weekly Progress

    // عدد الأنشطة المكتملة خلال آخر سبعة أيام
    func weeklyCompletedCounts() -> [Int] {

        // التقويم الحالي
        let calendar = Calendar.current

        // التاريخ الحالي
        let today = Date()

        // الإنجازات السابقة
        let progress = loadActivityProgress()

        // المرور على الأيام السبعة
        return (0..<7).map { index in

            // عدد الأيام السابقة
            let daysAgo = 6 - index

            // تحديد اليوم المطلوب
            guard let date = calendar.date(
                byAdding: .day,
                value: -daysAgo,
                to: today
            ) else {
                return 0
            }

            // حساب عدد الأنشطة المكتملة في نفس اليوم
            return progress.filter { record in
                calendar.isDate(record.date, inSameDayAs: date)
            }.count
        }
    }

    // MARK: - Reset

    // حذف سجلات الإنجازات فقط
    func resetProgress() {
        defaults.removeObject(forKey: Keys.activityProgress)
    }

    // حذف البيانات التي تديرها الخدمة
    func resetEverything() {
        defaults.removeObject(forKey: Keys.onboardingCompleted)
        defaults.removeObject(forKey: Keys.selectedInterests)
        defaults.removeObject(forKey: Keys.activityProgress)
        defaults.removeObject(forKey: Keys.sportCreatePlans)
    }
}
