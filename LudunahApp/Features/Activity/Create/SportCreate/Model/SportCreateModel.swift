import Foundation

struct SportCreateModel: Identifiable, Codable {
    var id = UUID()
    var sport: SportPlan
    var exerciseType: SportExerciseType
    var difficulty: SportDifficulty = .medium
    var space: SportSpace = .medium
    var playerCount = 3
    var durationMinutes = 3
    var planName = ""

    init(sport: SportPlan = .football) {
        self.sport = sport
        self.exerciseType = sport.defaultExerciseType
    }
}
