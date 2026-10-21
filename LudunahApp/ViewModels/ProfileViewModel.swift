import Foundation
import Observation

// ViewModel: holds the model and prepares it for display
@Observable
final class ProfileViewModel {
    private(set) var profile: Profile

    init(profile: Profile = Profile(name: "Athari", age: 21, about: "Hello Im Athari")) {
        self.profile = profile
    }

    var title: String {
        "\(profile.name), \(profile.age)"
    }

    var about: String {
        profile.about
    }
}
