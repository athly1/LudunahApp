import Combine

final class SportDoViewModel: ObservableObject {
    @Published private(set) var currentExercise: Activity?

    init() {
        currentExercise = (try? ContentService.loadActivities(for: .sport))?
            .first { $0.type == .doActivity }
    }
}
