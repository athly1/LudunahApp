import Foundation
import Combine
import SwiftUI

final class InstructionsSheetViewModel: ObservableObject {
    
    // MARK: - Activity information
    
    @Published var title = ""
    @Published var description = ""
    @Published var skills: [String] = []
    @Published var duration = ""
    @Published var typeTitle = ""
    
    // MARK: - Interest information
    @Published var interestTitle = ""
    @Published var interestColor: Color = .clear
    @Published var imageName = ""
    @Published var infoIcon = "info.circle"
    
    // MARK: - Selected activity
    let interest: Interest
    @Published var activity: Activity?
        
        init(interest: Interest, activity preselected: Activity? = nil) {
            self.interest = interest

            do {
                let activities = try ContentService.loadActivities(for: interest)

                // Select one random activity.
                // Use the activity chosen on Home, or pick a random one.
                guard let activity = preselected ?? activities.randomElement() else {
                    print("No activities found.")
                    return
                }

                // Save the selected activity for navigation.
                self.activity = activity

                // Keep your existing code below.
                title = activity.title
                description = activity.summary ?? ""
                skills = activity.skills ?? []
                duration = "\(activity.durationMin ?? 0) دقائق"
            
            // Convert activity type into Arabic.
            switch activity.type {
            case .learn:
                typeTitle = "تعلّم"
            case .doActivity:
                typeTitle = "تحدٍّ"
            case .create:
                typeTitle = "ابتكر"
            }
            
            // Set the selected interest's information.
            switch interest {
            case .art:
                interestTitle = "الفن"
                interestColor = .artChipBackground
                imageName = "paintpalette"
                
            case .gaming:
                interestTitle = "الألعاب الإلكترونية"
                interestColor = .gamingChip
                imageName = "gamecontroller"
                
            case .sport:
                interestTitle = "الرياضة"
                interestColor = .sportChip
                imageName = "figure.run"
            }
            
        } catch {
            print("Failed to load activities: \(error)")
        }
        
    }
}
