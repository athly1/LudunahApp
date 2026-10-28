import SwiftUI

struct SplashView: View {
    let onFinished: () -> Void

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Image("LudunahLogoNoBG")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                Text("لُــدونــــة")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            onFinished()
        }
    }
}

#Preview {
    SplashView(onFinished: {})
}
