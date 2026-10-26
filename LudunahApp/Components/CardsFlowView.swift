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
        
        VStack(spacing: -42) {
            
            //The current card
            let card = cards[index]
            let style = iconStyles[card.icon] ?? defaultStyle

            //One Card
            InfoCard(
                CardIcon: style.symbol,
                iconBackground: style.background,
                iconColor: style.color,
                text: card.text
            )
            .id(index) //new number = new card
            .transition(.push(from: .bottom)) //Key Transition: new card comes from the bottom
            .frame(maxHeight: .infinity)

            //if Last card Show Done button
            //otherwise Show swipe hint
            if index == cards.count - 1 {
                PrimaryButton(Title: "انتهيت") {
                    // Action Here going Home
                    onFinish() }
            } else {
                Image(systemName: "hand.draw")
                    .font(.system(size: 42))
                    .foregroundStyle(Color.textPrimary)
                    .rotationEffect(.degrees(15)) //tilt the hand
                  //move up then down, forever
                  .phaseAnimator([false, true]) { content, isUp in
                     content.offset(y: isUp ? -55 : 0)
                 } animation: { _ in
                     .easeInOut(duration: 0.8)
                 }
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
        CardData(icon: "hook", text: "تخيّل إنك لعبت على نفس الخريطة ٥٠ رتخيّل إنك لعبت على نفس الخريطة ٥٠ مرة. في أول مرة كنت تضيع وتسأل نفسك: وين أروح؟ الحين تعرف وين تختبئ، وأي طريق أقصر، ومن وين يجي الخصم، وكل هذا بدون ما تفكر."),
        CardData(icon: "brain", text: "في دماغك منطقة صغيرة اسمها الحُصين."),
        CardData(icon: "question", text: "تقدر ترسم خريطة لعبتك المفضلة من ذاكرتك؟")
    ])
}


