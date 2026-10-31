
import Combine

final class SportCreateViewModel: ObservableObject {

    // MARK: - Properties

    private let storage = StorageService()

    @Published var model: SportCreateModel
    @Published private(set) var didFinish = false

    // MARK: - Initialization

    init(sport: SportPlan = .football) {
        model = SportCreateModel(sport: sport)
    }

    // MARK: - Update Plan

    func setPlayerCount(_ count: Int) {
        model.playerCount = min(max(count, 2), 10)
    }

    func setDuration(_ minutes: Int) {
        model.durationMinutes = min(max(minutes, 1), 30)
    }

    // MARK: - Completion

    /// Saves the plan and records the completed activity once.
    func finish() {
        guard !didFinish else {
            return
        }

        didFinish = true

        storage.saveSportCreatePlan(model)

        storage.recordCompletedActivity(
            interest: .sport
        )
    }
}
