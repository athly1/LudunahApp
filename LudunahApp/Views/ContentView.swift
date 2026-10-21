import SwiftUI
import Playgrounds

// View: only UI, reads data from the ViewModel
struct ContentView: View {
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        List {
            VStack {
                Image(.profileFreeIconsDesignedByMagnific)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(.circle)

                Text(viewModel.title)
                    .font(.title)
                    .fontWeight(.semibold)
            }

            Section {
                Text(viewModel.about)
            } header: {
                Text("About")
            }
        }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
