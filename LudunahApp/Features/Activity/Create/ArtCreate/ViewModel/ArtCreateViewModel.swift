
// ArtCreateViewModel.swift - منطق أنشطة Art Create.
//
// Contains:
// - Random activity selection.
// - Grid painting and undo.
// - Color mixing predictions.
// - Result reveal and round navigation.
// - Creative reflection.
//
// Used by: ArtCreateView.
//
// Learn: @Observable, arrays, functions, computed properties.

import Foundation
import Observation

@MainActor
@Observable
final class ArtCreateViewModel {

    // MARK: - Activity

    private(set) var activity: ArtCreateModel?
    private(set) var errorMessage: String?

    // MARK: - Grid Activity

    // 25 مربعًا، nil يعني مربع غير ملوّن
    private(set) var grid: [Int?] = Array(
        repeating: nil,
        count: 25
    )

    // حفظ الحالات السابقة لزر التراجع
    private var gridHistory: [[Int?]] = []

    // اللون المختار
    var selectedColorIndex = 0

    // إجابة المستخدم عن معنى الرمز
    var reflection = ""

    var canUndo: Bool {
        !gridHistory.isEmpty
    }

    var hasDrawing: Bool {
        grid.contains { $0 != nil }
    }

    // MARK: - Color Lab

    private(set) var roundIndex = 0

    // توقع المستخدم في الجولة الحالية
    private(set) var selectedAnswer: String?

    // هل كشفنا النتيجة؟
    private(set) var isRevealed = false

    // اللون المختار من النتائج
    var favoriteRoundIndex: Int?

    // الاسم الإبداعي للون
    var inventedColorName = ""

    private(set) var isMixingComplete = false

    // MARK: - Initialization

    init() {
        loadActivity()
    }

    private func loadActivity() {

        do {
            let activities = try ArtCreateLoader.loadActivities()

            guard let selected = activities.randomElement() else {
                errorMessage = "لا توجد أنشطة إنشاء متاحة."
                return
            }

            activity = selected

        } catch {
            errorMessage = "تعذر تحميل أنشطة الإنشاء."
            print("Art Create loading error: \(error)")
        }
    }

    // MARK: - Grid Functions

    func paintCell(at index: Int) {

        guard grid.indices.contains(index),
              let activity,
              activity.colors.indices.contains(
                selectedColorIndex
              ) else {
            return
        }

        // لا نحفظ خطوة إذا لم يتغير اللون
        guard grid[index] != selectedColorIndex else {
            return
        }

        // حفظ الشبكة قبل التعديل
        gridHistory.append(grid)

        // تلوين المربع
        grid[index] = selectedColorIndex
    }

    func undo() {

        guard let previousGrid = gridHistory.popLast() else {
            return
        }

        grid = previousGrid
    }

    // MARK: - Mixing Properties

    var currentRound: ArtColorRound? {

        guard let activity,
              activity.rounds.indices.contains(roundIndex) else {
            return nil
        }

        return activity.rounds[roundIndex]
    }

    var totalRounds: Int {
        activity?.rounds.count ?? 0
    }

    var currentRoundNumber: Int {
        roundIndex + 1
    }

    var isLastRound: Bool {
        totalRounds > 0 &&
        roundIndex == totalRounds - 1
    }

    // MARK: - Mixing Functions

    func selectAnswer(_ answer: String) {

        guard !isRevealed,
              let round = currentRound,
              round.options.contains(answer) else {
            return
        }

        selectedAnswer = answer
    }

    func revealResult() {

        guard selectedAnswer != nil,
              currentRound != nil else {
            return
        }

        isRevealed = true
    }

    func nextRound() {

        guard isRevealed else {
            return
        }

        if isLastRound {
            isMixingComplete = true
            return
        }

        roundIndex += 1
        selectedAnswer = nil
        isRevealed = false
    }

    // MARK: - Completion

    var canFinish: Bool {

        guard let activity else {
            return false
        }

        if activity.id == "art-create-1" {
            return hasDrawing
        }

        if activity.id == "art-create-2" {
            return isMixingComplete &&
                favoriteRoundIndex != nil
        }

        return false
    }
}
