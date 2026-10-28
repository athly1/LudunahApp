
// ArtDoModel.swift - بيانات نشاط التكوين البصري الصامت.
//
// Contains:
// - Sunset color palette.
// - Five-minute activity duration.
// - Ten-second reflection duration.
// - Activity instructions.
//
// Used by: ArtDoViewModel.
// Learn: struct, arrays, stored properties.

import Foundation

// MARK: - Art Do Model

struct ArtDoModel {

    // عنوان النشاط
    let title: String

    // موضوع لوحة اليوم
    let theme: String

    // الألوان المطلوبة
    let colors: [String]

    // مدة جمع العناصر وترتيبها
    let activityDuration: Int

    // مدة التأمل بعد الضغط على أنهيت
    let reflectionDuration: Int

    // تعليمات النشاط
    let howTo: [String]

    // تعليمات شاشة التأمل
    let reflectionText: String

    // MARK: - Sunset Activity

    static let sunset = ArtDoModel(

        title: "التكوين البصري الصامت",

        theme: "غروب الشمس",

        colors: [
            "#D9A38F",
            "#E0915F",
            "#D7A04E"
        ],

        // خمس دقائق
        activityDuration: 300,

        // عشر ثوانٍ
        reflectionDuration: 10,

        howTo: [
            "تحرك في مساحتك واجمع 3 عناصر حقيقية تحمل هذه الألوان أو درجات قريبة منها.",
            "رتبها أمامك لتشكل لوحة صامتة مستوحاة من بيئتك.",
            "بعد الانتهاء، ابتعد خطوة للخلف وتأمل عملك."
        ],

        reflectionText:
            "ابتعد خطوة للخلف، وتأمل التناغم اللوني في لوحتك."
    )
}
