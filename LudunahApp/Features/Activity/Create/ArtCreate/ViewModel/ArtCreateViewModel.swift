
// ArtCreateViewModel.swift - منطق نشاط ابتكر في الفن السعودي.
//
// Contains:
// - An @Observable class with user grid and selected color.
// - Available colors from activity content.
// - Methods to select color, paint cell, undo, clear, and save.
// - User's answer describing their symbol.
//
// Used by: ArtCreateView.
// Learn: @Observable, arrays, Set, guard, functions,
//       JSONEncoder, UserDefaults, undo history.

import Foundation
import Observation

// MARK: - Art Create ViewModel

// يدير التفاعل مع شبكة الرسم في نشاط ابتكر
@Observable
final class ArtCreateViewModel {

    // MARK: - Properties

    // التصميم الحالي للمستخدم (شبكة 5 × 5)
    private(set) var pattern = ArtCreateModel()

    // الألوان المتاحة من بيانات النشاط
    let availableColors: [String] = [
        "#E8D5C4",
        "#8B3A2F",
        "#3A2A2A",
        "#D9A38F",
        "#2F5D4A",
        "#D7A04E"
    ]

    // اللون المحدد حاليًا
    private(set) var selectedColor: String = "#8B3A2F"

    // الإجابة عن معنى الرمز الذي صممه المستخدم
    var answer: String = ""

    // حفظ الحالات السابقة لدعم التراجع
    private var undoHistory: [[String]] = []

    // مفتاح حفظ التصميم في الجهاز
    private let storageKey = "artCreateDraft"

    // MARK: - Color Selection

    // تغيير اللون المستخدم في الرسم
    func selectColor(_ color: String) {

        // التأكد أن اللون ضمن الألوان المسموحة
        guard availableColors.contains(color) else {
            return
        }

        // تحديث اللون المحدد
        selectedColor = color
    }

    // MARK: - Paint Cell

    // تلوين مربع معين داخل الشبكة
    func paintCell(at index: Int) {

        // التأكد أن رقم المربع صحيح
        guard pattern.cellColors.indices.contains(index) else {
            return
        }

        // منع تسجيل خطوة إذا كان المربع بنفس اللون
        guard pattern.cellColors[index] != selectedColor else {
            return
        }

        // حفظ حالة الشبكة قبل التغيير
        undoHistory.append(pattern.cellColors)

        // تغيير لون المربع المحدد
        pattern.cellColors[index] = selectedColor
    }

    // MARK: - Undo

    // هل توجد خطوة يمكن التراجع عنها؟
    var canUndo: Bool {
        !undoHistory.isEmpty
    }

    // التراجع عن آخر تغيير
    func undo() {

        // التأكد أن فيه حالة سابقة
        guard let previousColors = undoHistory.popLast() else {
            return
        }

        // استرجاع ألوان الشبكة السابقة
        pattern.cellColors = previousColors
    }

    // MARK: - Clear

    // مسح جميع الألوان وإعادة المربعات للون الأبيض
    func clear() {

        // التأكد أن فيه ألوانًا تستحق المسح
        guard pattern.cellColors.contains(where: { $0 != "#FFFFFF" }) else {
            return
        }

        // حفظ الشبكة السابقة لإمكانية التراجع
        undoHistory.append(pattern.cellColors)

        // إعادة جميع المربعات للون الافتراضي
        pattern.cellColors = Array(
            repeating: "#FFFFFF",
            count: pattern.rows * pattern.columns
        )
    }

    // MARK: - Validation

    // هل المستخدم لوّن مربعًا واحدًا على الأقل؟
    var hasDrawing: Bool {
        pattern.cellColors.contains { $0 != "#FFFFFF" }
    }

    // هل الإجابة النصية غير فارغة؟
    var hasAnswer: Bool {
        !answer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // هل يمكن إنهاء النشاط؟
    var canFinish: Bool {
        hasDrawing && hasAnswer
    }

    // MARK: - Save

    // حفظ مسودة تصميم المستخدم محليًا
    func save() -> Bool {

        // تحويل التصميم إلى JSON Data
        guard let data = try? JSONEncoder().encode(pattern) else {
            return false
        }

        // حفظ مسودة التصميم باستخدام المفتاح المحدد
        UserDefaults.standard.set(data, forKey: storageKey)

        // إرجاع نجاح طلب الحفظ
        return true
    }
}
