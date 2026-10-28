
// ArtLearnModel.swift - بيانات نشاط تعلّم الفن السعودي.
//
// Contains:
// - Art learning activity data.
// - Activity title, image, cards and insight.
// - Loads Learn activities from Art.json.
// - Reuses ActivityCard from the shared model.
//
// Used by: ArtLearnViewModel.
// Learn: struct, Decodable, JSONDecoder, Bundle.

import Foundation

// MARK: - Art Learn Model

struct ArtLearnModel: Decodable, Identifiable {

    // معرف النشاط
    let id: String

    // عنوان النشاط
    let title: String

    // اسم الصورة داخل Assets
    let image: String?

    // البطاقات التعليمية
    let cards: [ActivityCard]

    // ملخص ما تعلمه المستخدم
    let insight: String?

    // المصادر
    let sources: [String]?
}

// MARK: - JSON Container

// يمثل قائمة الأنشطة داخل Art.json
private struct ArtLearnContainer: Decodable {

    let activities: [ArtLearnEntry]
}

// MARK: - JSON Entry

// نقرأ فقط الحقول التي نحتاجها
private struct ArtLearnEntry: Decodable {

    let id: String
    let type: String
    let title: String
    let image: String?
    let cards: [ActivityCard]?
    let insight: String?
    let sources: [String]?

    // تحويل نشاط Learn إلى ArtLearnModel
    var learnModel: ArtLearnModel? {

        // نتأكد أنه نشاط تعلّم وعنده بطاقات
        guard type == "learn",
              let cards,
              !cards.isEmpty else {
            return nil
        }

        return ArtLearnModel(
            id: id,
            title: title,
            image: image,
            cards: cards,
            insight: insight,
            sources: sources
        )
    }
}

// MARK: - Art Learn Loader

enum ArtLearnLoader {

    static func loadActivities() throws -> [ArtLearnModel] {

        // البحث عن Art.json داخل التطبيق
        guard let url = Bundle.main.url(
            forResource: "Art",
            withExtension: "json"
        ) else {
            throw CocoaError(.fileNoSuchFile)
        }

        // قراءة بيانات الملف
        let data = try Data(contentsOf: url)

        // تحويل JSON إلى Swift
        let container = try JSONDecoder().decode(
            ArtLearnContainer.self,
            from: data
        )

        // اختيار أنشطة Learn فقط
        return container.activities.compactMap {
            $0.learnModel
        }
    }
}
