// StorageService.swift - storage + weekly progress.
//
// Contains:
// - A final class, the only place that reads and writes saved data (UserDefaults).
// - Save and load: onboarding completed, selected interests.
// - Record a completed activity (ActivityProgress).
// - Weekly progress: completed count for each of the last 7 days.
// - Reset progress, reset everything.
//
// Used by: AppState, HomeViewModel.
// Learn: UserDefaults, Codable, JSONEncoder, Calendar
import Foundation
// كلاس مسؤول عن حفظ واسترجاع بيانات التطبيق
final class StorageService {

    // MARK: - Properties

    // الوصول إلى التخزين المحلي الخاص بالتطبيق
    private let defaults = UserDefaults.standard

    // مفاتيح ثابتة نستخدمها لتحديد مكان كل بيانات
    private enum Keys {
        static let onboardingCompleted = "onboardingCompleted"
        static let selectedInterests = "selectedInterests"
        static let activityProgress = "activityProgress"
    }

    // MARK: - Onboarding

    // حفظ حالة إكمال صفحات البداية
    func saveOnboardingCompleted(_ completed: Bool) {

        // حفظ true أو false في التخزين المحلي
        defaults.set(completed, forKey: Keys.onboardingCompleted)
    }

    // استرجاع حالة إكمال صفحات البداية
    func loadOnboardingCompleted() -> Bool {

        // قراءة القيمة المحفوظة، أو false إذا لم توجد
        return defaults.bool(forKey: Keys.onboardingCompleted)
    }

    // MARK: - Selected Interests

    // حفظ الاهتمامات التي اختارها المستخدم
    func saveSelectedInterests(_ interests: Set<Interest>) {

        // تحويل الاهتمامات إلى بيانات قابلة للتخزين
        guard let data = try? JSONEncoder().encode(interests) else {
            return
        }

        // حفظ البيانات في UserDefaults
        defaults.set(data, forKey: Keys.selectedInterests)
    }

    // استرجاع الاهتمامات المحفوظة
    func loadSelectedInterests() -> Set<Interest> {

        // محاولة قراءة البيانات المحفوظة
        guard let data = defaults.data(forKey: Keys.selectedInterests) else {
            return []
        }

        // تحويل البيانات إلى مجموعة اهتمامات
        return (try? JSONDecoder().decode(
            Set<Interest>.self,
            from: data
        )) ?? []
    }

    // MARK: - Activity Progress

    // تسجيل نشاط جديد أكمله المستخدم
    func recordCompletedActivity(interest: Interest) {

        // استرجاع الإنجازات السابقة
        var progress = loadActivityProgress()

        // إنشاء سجل جديد بتاريخ اليوم والوقت الحالي
        let newRecord = ActivityProgress(interest: interest)

        // إضافة السجل الجديد إلى القائمة
        progress.append(newRecord)

        // حفظ قائمة الإنجازات بعد التحديث
        saveActivityProgress(progress)
    }

    // حفظ قائمة الإنجازات
    private func saveActivityProgress(_ progress: [ActivityProgress]) {

        // تحويل قائمة الإنجازات إلى بيانات
        guard let data = try? JSONEncoder().encode(progress) else {
            return
        }

        // حفظ البيانات محليًا
        defaults.set(data, forKey: Keys.activityProgress)
    }

    // استرجاع قائمة الإنجازات
    func loadActivityProgress() -> [ActivityProgress] {

        // قراءة البيانات المحفوظة
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

    // حساب عدد الأنشطة المكتملة لكل يوم من آخر 7 أيام
    func weeklyCompletedCounts() -> [Int] {

        // الحصول على التقويم حسب إعدادات الجهاز
        let calendar = Calendar.current

        // الحصول على التاريخ والوقت الحاليين
        let today = Date()

        // استرجاع جميع الإنجازات السابقة
        let progress = loadActivityProgress()

        // المرور على آخر 7 أيام من الأقدم إلى اليوم
        return (0..<7).map { index in

            // حساب عدد الأيام السابقة
            let daysAgo = 6 - index

            // حساب تاريخ اليوم المطلوب
            guard let date = calendar.date(
                byAdding: .day,
                value: -daysAgo,
                to: today
            ) else {
                return 0
            }

            // حساب الإنجازات المكتملة في هذا اليوم
            return progress.filter { record in

                // مقارنة تاريخ الإنجاز باليوم المطلوب
                calendar.isDate(
                    record.date,
                    inSameDayAs: date
                )

            }.count
        }
    }

    // MARK: - Reset

    // حذف سجلات الإنجاز فقط
    func resetProgress() {

        // إزالة الإنجازات من التخزين
        defaults.removeObject(forKey: Keys.activityProgress)
    }

    // حذف جميع بيانات التطبيق التي تديرها هذه الخدمة
    func resetEverything() {

        // حذف حالة إكمال صفحات البداية
        defaults.removeObject(forKey: Keys.onboardingCompleted)

        // حذف الاهتمامات المختارة
        defaults.removeObject(forKey: Keys.selectedInterests)

        // حذف سجلات الإنجازات
        defaults.removeObject(forKey: Keys.activityProgress)
    }
}
    
