// Used By Learn type of Activity (Sport + Gaming), Swipe Up Stack of Cards
import SwiftUI


// MARK: - One Card Build
struct InfoCard: View {
    
    //Inputs that changes from card to card
    let CardIcon: String // SF Symbol name
    let iconBackground: Color // color of the soft box behind the icon
    var iconColor: Color // icon color
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
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 8)
    }
}


// MARK: - Shows the cards one by one, swipe up for the next one
struct CardsFlowView: View {

   // Inputs
   var iconColor: Color // Icon color
   var iconActivityBackground: Color // Color behind the icon

   let cards: [ActivityCard] // All cards in order

   // The parent view owns the index and passes it here.
   // CardsFlowView displays the requested card but does not
   // decide which card is currently selected.
   let index: Int

   // Called when the user swipes up.
   // The parent decides how to update the index.
   var onNext: () -> Void

   var body: some View {

       // Only this ScrollView making it scrollable
       ScrollView {
           VStack(spacing: 200) {

               // Check that the index points to a real card.
               // This also prevents a crash if the array is empty.
               if cards.indices.contains(index) {

                   // The current card
                   let card = cards[index]

                   // One Card
                   InfoCard(
                       CardIcon: card.icon,
                       iconBackground: iconActivityBackground,
                       iconColor: iconColor,
                       text: card.text
                   )
                   .id(index) // A new index means a new card
                   .transition(.push(from: .bottom)) // THE transition
                   // New card comes from the bottom
                   .frame(maxWidth: .infinity)

                   // If NOT the last card, show the swipe hint
                   if index < cards.count - 1 {
                       Image(systemName: "hand.draw")
                           .font(.system(size: 42))
                           .foregroundStyle(Color.textPrimary)
                           .rotationEffect(.degrees(15)) // Tilt the hand
                           // Move up then down, forever
                           //animate bettwen 2 phases
                           .phaseAnimator([false, true]) { content, isUp in
                               //Moves it 55 upward then to original position
                               content.offset(y: isUp ? -55 : 0)
                           } animation: { _ in
                               .easeInOut(duration: 0.8)
                           }
                   }
               }
           }
           .padding(.horizontal, 16)
           .padding(.vertical, 24)
           .frame(maxWidth: .infinity)
           //make the intended rectangular card area interactive.
           .contentShape(Rectangle())
           
           
           // Makes the card area respond to a swipe
           .gesture(
               DragGesture().onEnded { drag in

                   // An upward swipe must exceed 80 points.
                   // Ask the parent to advance to the next card.
                   if drag.translation.height < -80 &&
                       index < cards.count - 1 {
                       onNext()
                   }
               }
           )
           .environment(\.layoutDirection, .rightToLeft)
           // Keep the Arabic layout
       }
       .scrollIndicators(.hidden) // Hide the scroll bar
   }
}
