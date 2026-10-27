
// ActivityProgress.swift - سجل نشاط مكتمل.
//
// Contains:
// - Date and interest of completed activity.
// - Codable and Hashable support.
//
// Used by: StorageService, WeeklyProgressChart.
// Learn: struct, Date, init, Codable.

import Foundation

// يمثل سجل إنجاز واحد
struct ActivityProgress: Codable, Hashable {

    // وقت إكمال النشاط
    let date: Date

    // الاهتمام المرتبط بالنشاط
    let interest: Interest

    // إنشاء سجل جديد
    init(date: Date = Date(), interest: Interest) {

        // حفظ التاريخ
        self.date = date

        // حفظ الاهتمام
        self.interest = interest
    }
}
