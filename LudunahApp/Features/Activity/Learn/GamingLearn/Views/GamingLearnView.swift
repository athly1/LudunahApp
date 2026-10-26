// GamingLearnView.swift - Gaming "Learn" step.
//
// Contains:
// - A View that explains today's game idea and rules.
// - Reads its data from GamingLearnViewModel.
//
// Used by: ActivityFlowView (gaming, learn).

import SwiftUI


// a struct is ightweighted thing not a class and this one of type View Protocol
struct gameLearnView: View {
    
    //Change Later When design System Happens
    let BG: Color = Color(red: 244/255, green: 242/255, blue: 236/255)
    let TxtPrimary: Color = Color(red: 0.416, green: 0.306, blue: 0.165, opacity: 1.00)
    let LudunahPrimary: Color = Color(red: 0.761, green: 0.835, blue: 0.886, opacity: 1.00)
    let GameTint: Color = Color(red: 0.867, green: 0.847, blue: 0.953, opacity: 1.00)
    
    
    //progress bar
    var currentCard: Double = 1
    var totalCards: Double = 4
    
    //Learning Content
    var title: String = "مثال"
    
    //data var & let (considered its attributes and can be passed to the view when its called), Swift auto-creates its init
    //state (properites tht lesson for changes, owned by this view and it the values that change, so lessiong for any changes)
    
    // the properity veiw struct must hold which holds all that appears in screen
    
    //having 'some' View makes the type decided at run time where the body cah retruend any builded screen elements witouh having to complay to spcesif type
    var body: some View {
        ZStack{
            List(){
                // Modifiers on a Group are applied to every row inside it,
                // so the clear background + hidden separator are written once.
                Group {
                HStack{

                    Button{
                        //Action
                    }
                    label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 12, weight: .bold))
                    }.buttonStyle(.glass)
                        .frame(width: 37,height: 37)
                    
                    Text("النشاط اليومي").foregroundColor(TxtPrimary)
                        .frame(maxWidth: .infinity, alignment: .center)

                }

                HStack(spacing: 8){
                    
                    Text("الالعاب الالكترونيه").foregroundColor(TxtPrimary)
                        .padding(.horizontal,11)
                        .padding(.vertical, 8)
                        .background(GameTint)
                        .cornerRadius(999)
                   
                    
                    Label("تعلّم", systemImage: "lightbulb.max").foregroundColor(TxtPrimary)
                        .padding(.horizontal,11)
                        .padding(.vertical, 8)
                        .background(LudunahPrimary)
                        .cornerRadius(999)
                }

                ProgressView(value: currentCard,total:totalCards)
                    .scaleEffect(y: 1.5)
                    .tint(LudunahPrimary)

                Text(title)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

            }
            // Hide the List's default gray background so BG shows through
            .scrollContentBackground(.hidden)

        }.background(BG)
    }
  
}

#Preview {
          gameLearnView()
              .environment(\.locale, Locale(identifier: "ar"))
              .environment(\.layoutDirection, .rightToLeft)
      }



