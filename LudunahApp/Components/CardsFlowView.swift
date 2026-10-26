import SwiftUI

struct InfoCard: View {
    //Inputs that changes from card to card
    let CardIcon: String // SF Symbol name
    let iconBackground: Color // color of the soft box behind the icon
    var iconColor: Color = Color.mapSequers // icon color
    let text: String // Content

    var body: some View {
        
        VStack(spacing: 12) {
            
            //Icon inside a rounded colored box
            Image(systemName: CardIcon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(iconColor)
                .frame(width: 48, height: 37)
                .background(iconBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            //Body text
            Text(text)
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                //text take the whole horizontal area but vetical contain safe area 23
                .fixedSize(horizontal: false, vertical: true)
                .frame(minHeight: 95)
        }
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 8)
    }
}

//Shows the cards one by one, swipe up for the next one

struct CardsFlowView: View {
    //Inputs
    let cards: [CardData] //All cards in order
    var onFinish: () -> Void = {} //What happens when user taps "انتهيت"

    //Number of the card on screen (starts at 0)
    @State private var index = 0

    var body: some View {
        
        VStack(spacing: 40) {
            
            //The current card
            let card = cards[index]
            let style = iconStyles[card.icon] ?? defaultStyle

            InfoCard(
                CardIcon: style.symbol,
                iconBackground: style.background,
                iconColor: style.color,
                text: card.text
            )
            .id(index) //new number = new card
            .transition(.push(from: .bottom)) //new card comes from the bottom
            .frame(maxHeight: .infinity)

            //Last card → button, otherwise → swipe hint
            if index == cards.count - 1 {
                Button("انتهيت") { onFinish() }
            } else {
                Image(systemName: "hand.point.up")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.textPrimary)
                    .symbolEffect(.bounce, options: .repeating)
            }
        }
        .padding(.horizontal, 16)
        .contentShape(Rectangle()) //whole screen can be swiped
        .gesture(
            DragGesture().onEnded { drag in
                //swiped up enough and not on the last card → next card
                if drag.translation.height < -80 && index < cards.count - 1 {
                    withAnimation { index += 1 }
                }
            }
        )
        .environment(\.layoutDirection, .rightToLeft)  // Arabic layout
    }
}

#Preview {
    CardsFlowView(cards: [
        CardData(icon: "hook", text: "تخيّل إنك لعبت على نفس الخريطة ٥٠ مرة."),
        CardData(icon: "brain", text: "في دماغك منطقة صغيرة اسمها الحُصين."),
        CardData(icon: "question", text: "تقدر ترسم خريطة لعبتك المفضلة من ذاكرتك؟")
    ])
}


