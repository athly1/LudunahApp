// Enum with cases art, sport, gaming and a String raw value.
// Computed title and icon name.

// Used by: onboarding, Home, Activity screens, AppState, StorageService.

// Conforms to CaseIterable ( make an array of the cases) , Identifiable (each with id to be able to run ForEach function)
enum Interest: String, CaseIterable, Identifiable {
    case art
    case sports
    case gaming
    case cooking

    var id: Self { self }

    var name: String {
        switch self {
        case .art: "الفن السعودي"
        case .sports: "الرياضة"
        case .gaming: "الألعاب الإلكترونية"
        case .cooking:  "الطبخ"
        }
    }
}
