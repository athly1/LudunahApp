// bottom button (ابدأ / التالي).
// A View with a full-width prominent button.
// Inputs: title, action.
// Uses DesignSystem fonts and colors. Supports the disabled state.
// Used by: OnboardingView, TaskSheet, ActivityFlowView, InstructionsSheet.

import SwiftUI

struct PrimaryButton: View {
    
    var Title: String
    //the action it does, passed when calling the Button in a View Struct
    let action: () -> Void
    
    var body: some View {
        
        Button{
        //Action
        } label:{
            Text(Title)
                .font(.primaryButton)
                .foregroundColor(.textPrimary)
                .frame(maxHeight: Spacing.ButtonTextPaddingHeight)
        
        }.buttonStyle(.glass)
            .buttonSizing(.flexible) //to size with frame
            .frame(maxWidth: Spacing.ButtonWidth ,alignment: .center)
        
    }
}

//Example on using it as start button with a simple action passed to it
#Preview {
    PrimaryButton(Title: "ابدأ") {
        print("pressed")
    }
}
