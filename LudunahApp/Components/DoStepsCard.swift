/*import SwiftUI

//Shows number of Steps in a Do activity
struct DoStepsCard: View {
    
    //Inputs that changes from card to card
    let HowTo: [String] = []//Steps
    var stepRingColor: Color // Step color

    var body: some View {
        
        VStack(spacing: 12) {
            //Body text
            List(HowTo, .) {
                
         Text(HowTo)
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                //text take the whole horizontal area but vetical contain safe area 23
                .fixedSize(horizontal: false, vertical: true)

        }
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 8)
    }
}

#Preview{
    DoStepsCard(HowTo: "", stepRingColor: Color.blue )
}
*/
