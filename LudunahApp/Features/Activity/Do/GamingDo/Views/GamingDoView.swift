// GamingDoView.swift - Gaming "Do" step: play the challenge.
//
// Contains:
// - The game board and score.
// - Sends taps to GamingDoViewModel.
//
// Used by: ActivityFlowView (gaming, do).

import SwiftUI

struct gamingDoView: View {
    
    var body: some View{
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()
            
            // The main page is a VStack
            VStack(alignment: .leading,spacing:0){
                
                // MARK: - Fixed Header, Progress, and Title
                
                // Shared header: back button + title + chips
                ActivityHeader(
                    interestTitle: "الألعاب الإلكترونية",
                    interestColor: .gamingChip,
                    stepTitle: "طبّق",
                    stepIcon: "gamecontroller",
                    onBack: {}
                )
                .padding(.horizontal, Spacing.pageMargin)
                
                
                // MARK: - Title of today's Do
                Text("العب مباراه وحده باستخدام ازرار معكوسه في لوحه التحكم")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.chipHeight)
                    .padding(.bottom, Spacing.space8)
                
                // MARK: - SubTitle of today's Do
                HStack (spacing: 8) {
                    
                    Image(systemName: "gauge.with.needle")
                        .foregroundStyle(Color.textPrimary).opacity(0.75)
                    
                    Text("امامك 5 دقائق")
                        .font(.supTitle2)
                        .foregroundStyle(Color.textPrimary).opacity(0.75)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal, Spacing.pageMargin)
                
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
        
        
    }
    
}


#Preview {
    gamingDoView()
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}
