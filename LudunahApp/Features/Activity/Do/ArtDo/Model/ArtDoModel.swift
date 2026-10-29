
// ArtDoModel.swift - بيانات أنشطة تطبيق الفن.
//
// Contains:
// - Art Do activities.
// - Activity descriptions.
// - Colors or SF Symbols.
// - Timed phases.
// - Optional pause permission for each phase.
// - Loads activities from Art.json.
//
// Used by: ArtDoViewModel.
//
// Learn: struct, Decodable, JSONDecoder, Bundle.

import Foundation

// MARK: - Art Do Phase

// يمثل مرحلة واحدة داخل النشاط
struct ArtDoPhase: Decodable {

    // مدة المرحلة بالثواني
    let durationSec: Int

    // تعليمات المرحلة
    let text: String

    // هل يُسمح بإيقاف المؤقت مؤقتًا؟
    let allowPause: Bool
}

// MARK: - Art Do Model

struct ArtDoModel: Identifiable {

    // معرف النشاط
    let id: String

    // عنوان النشاط
    let title: String

    // وصف النشاط
    let description: String

    // موضوع النشاط
    let theme: String

    // نوع البطاقة: colors أو symbols
    let displayType: String

    // ألوان النشاط الأول
    let colors: [String]

    // رموز النشاط الثاني
    let symbols: [String]

    // مدة التطبيق الأساسية بالدقائق
    let durationMin: Int

    // خطوات النشاط
    let howTo: [String]

    // مراحل النشاط
    let phases: [ArtDoPhase]

    // المصادر
    let sources: [String]
}

// MARK: - JSON Container

// يمثل قائمة الأنشطة داخل Art.json
private struct ArtDoContainer: Decodable {

    let activities: [ArtDoEntry]
}

// MARK: - JSON Entry

// قراءة الحقول المطلوبة من JSON
private struct ArtDoEntry: Decodable {

    let id: String
    let type: String
    let title: String

    let description: String?
    let theme: String?
    let displayType: String?

    let colors: [String]?
    let symbols: [String]?

    let durationMin: Int?
    let howTo: [String]?
    let phases: [ArtDoPhase]?
    let sources: [String]?

    // MARK: - Convert to Model

    var doModel: ArtDoModel? {

        // اختيار أنشطة Do التي تحتوي على مراحل صحيحة
        guard type == "do",
              let phases,
              !phases.isEmpty,
              phases.allSatisfy({
                  $0.durationSec > 0
              }) else {
            return nil
        }

        let totalSeconds = phases.reduce(0) {
            $0 + $1.durationSec
        }

        return ArtDoModel(
            id: id,
            title: title,
            description: description ?? "",
            theme: theme ?? "",
            displayType: displayType ?? "colors",
            colors: colors ?? [],
            symbols: symbols ?? [],
            durationMin: durationMin
                ?? Int(ceil(Double(totalSeconds) / 60)),
            howTo: howTo ?? [],
            phases: phases,
            sources: sources ?? []
        )
    }
}

// MARK: - Art Do Loader

enum ArtDoLoader {

    static func loadActivities() throws -> [ArtDoModel] {

        // العثور على Art.json داخل التطبيق
        guard let url = Bundle.main.url(
            forResource: "Art",
            withExtension: "json"
        ) else {
            throw CocoaError(.fileNoSuchFile)
        }

        // قراءة الملف
        let data = try Data(contentsOf: url)

        // تحويل snake_case إلى camelCase
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // فك الترميز
        let container = try decoder.decode(
            ArtDoContainer.self,
            from: data
        )

        // إرجاع أنشطة Do فقط
        return container.activities.compactMap {
            $0.doModel
        }
    }
}
