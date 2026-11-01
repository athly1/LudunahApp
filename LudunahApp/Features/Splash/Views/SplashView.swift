import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Image("LudunahLogoNoBG")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                Text("لُــدُونــــه")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
            }
        }
    }
}

#Preview {
    SplashView()
}
