import Combine

final class SportDoViewModel: ObservableObject {
    @Published private(set) var currentExercise: Activity?

    // activityID: النشاط المختار من الهوم. إذا لم يُرسل نأخذ أول نشاط تطبيق.
    init(activityID: String? = nil) {
        let doActivities =
            ((try? ContentService.loadActivities(for: .sport)) ?? [])
                .filter { $0.type == .doActivity }

        currentExercise =
            doActivities.first(where: { $0.id == activityID })
            ?? doActivities.first
    }
}
