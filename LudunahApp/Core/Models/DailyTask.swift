// DailyTask.swift - one suggested task for today.
//
// Contains:
// - Struct with: id, interest, title, description, minutes.
// - Conforms to Identifiable, Hashable.
//
// Used by: HomeViewModel, HomeView, TaskSheet.


import Foundation

struct DailyTask: Identifiable, Hashable {
    let id: String
    let interest: Interest
    let title: String
    let description: String?
    let skills: [String]?
    let minutes: Int?

    init(activity: Activity, interest: Interest) {
        self.id = activity.id
        self.interest = interest
        self.title = activity.title
        self.description = activity.summary
        self.skills = activity.skills
        self.minutes = activity.durationMin
    }
}

