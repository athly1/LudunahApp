
// ArtCreateModel.swift - تصميم المستخدم في نشاط الفن.
//
// Contains:
// - Struct with id, date, rows, columns, cellColors.
// - Default 5x5 grid.
// - Stores colors as HEX strings.
//
// Used by: ArtCreateViewModel.
// Learn: struct, UUID, Date, Array, init, Codable.

import Foundation // يوفر UUID و Date

// يمثل تصميمًا واحدًا أنشأه المستخدم
struct ArtCreateModel: Identifiable, Codable {

    // معرّف فريد لكل تصميم
    let id: UUID

    // تاريخ ووقت إنشاء التصميم
    let date: Date

    // عدد صفوف الشبكة
    let rows: Int

    // عدد أعمدة الشبكة
    let columns: Int

    // ألوان المربعات على شكل نصوص HEX
    var cellColors: [String]

    // MARK: - Initializer

    // إنشاء تصميم جديد
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        rows: Int = 5,
        columns: Int = 5,
        defaultColor: String = "#FFFFFF"
    ) {

        // حفظ معرّف التصميم
        self.id = id

        // حفظ تاريخ الإنشاء
        self.date = date

        // تحديد عدد الصفوف
        self.rows = rows

        // تحديد عدد الأعمدة
        self.columns = columns

        // إنشاء المربعات باللون الأبيض
        self.cellColors = Array(
            repeating: defaultColor,
            count: rows * columns
        )
    }
}
