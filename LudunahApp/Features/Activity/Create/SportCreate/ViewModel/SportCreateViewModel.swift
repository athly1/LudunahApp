import Combine

final class SportCreateViewModel: ObservableObject {
    private let storage = StorageService()

    @Published var model: SportCreateModel
    @Published private(set) var didFinish = false

    init(sport: SportPlan = .football) {
        model = SportCreateModel(sport: sport)
    }

    func setPlayerCount(_ count: Int) {
        model.playerCount = min(max(count, 2), 10)
    }

    func setDuration(_ minutes: Int) {
        model.durationMinutes = min(max(minutes, 1), 30)
    }

    func finish() {
        storage.saveSportCreatePlan(model)
        didFinish = true
    }
}

