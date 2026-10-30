//
//  SportLearnViewModel.swift
//  LudunahApp
//
//  Created by Ghadi on 17/05/1448 AH.
//

import Combine

final class SportLearnViewModel: ObservableObject {
    @Published private(set) var index = 0
    @Published private(set) var title = ""
    @Published private(set) var cards: [ActivityCard] = []

    // activityID: النشاط المختار من الهوم. إذا لم يُرسل نأخذ أول نشاط تعلّم.
    init(activityID: String? = nil) {
        let learnActivities =
            ((try? ContentService.loadActivities(for: .sport)) ?? [])
                .filter { $0.type == .learn }

        let firstLearnActivity =
            learnActivities.first(where: { $0.id == activityID })
            ?? learnActivities.first

        title = firstLearnActivity?.title ?? ""
        cards = firstLearnActivity?.cards ?? []
    }

    var totalCards: Int {
        cards.count
    }

    var currentProgress: Double {
        totalCards == 0 ? 0 : Double(index + 1)
    }

    var isLastCard: Bool {
        !cards.isEmpty && index == cards.count - 1
    }

    func nextCard() {
        guard !cards.isEmpty, index < cards.count - 1 else { return }
        index += 1
    }

    func previousCard() {
        guard index > 0 else { return }
        index -= 1
    }
}
