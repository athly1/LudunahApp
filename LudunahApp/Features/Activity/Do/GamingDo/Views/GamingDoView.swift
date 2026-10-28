import SwiftUI

struct gamingDoView: View {
    
    @StateObject private var viewModel: GamingDoViewModel
    @StateObject private var timerEngine: TimerEngine

    init() {
        let viewModel = GamingDoViewModel()

        _viewModel = StateObject(wrappedValue: viewModel)
        _timerEngine = StateObject(
            wrappedValue: TimerEngine(
                duration: viewModel.durationMin * 60)
        )
    }
    
    @State private var hasStarted = false
    @State private var isPaused = false
    @State private var isDone = false
    
    //Close the page
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()
            
            //takes up the remaining vertical space
            Spacer(minLength: 0)
            // The main page is a VStack
            VStack(spacing: 0) {
                
                // MARK: - back button + title + chips
                ActivityHeader(
                    interestTitle: "الألعاب الإلكترونية",
                    interestColor: .gamingChip,
                    stepTitle: "طبّق",
                    stepIcon: "gamecontroller",
                    onBack: {
                        
                        dismiss()
                    }
                )
                .padding(.horizontal, Spacing.pageMargin)
                
                // MARK: - Title of today's Do
                Text(viewModel.title)
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.top, Spacing.chipHeight)
                    .padding(.bottom, Spacing.space8)
                
                // MARK: - SubTitle of today's Do
                HStack(spacing: 8) {
                    Image(systemName: "gauge.with.needle")
                        .foregroundStyle(Color.textPrimary)
                        .opacity(0.75)
                    
                    Text("امامك \(viewModel.durationMin) دقائق")
                        .font(.supTitle2)
                        .foregroundStyle(Color.textPrimary)
                        .opacity(0.75)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.bottom, Spacing.space32)
                
                // MARK: - Steps to Do
                DoStepsCard(
                    howTo: viewModel.steps,
                    stepRingColor: Color.mapSequers
                )
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.bottom, Spacing.space32)
                
                // MARK: - CountDownTimer
                CountdownTimerView(
                    engine: timerEngine,
                    color: .mapTimerRing
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, Spacing.headerTitleOffset)
                .padding(.top, Spacing.headerTitleOffset)
                
                //takes up the remaining vertical space so button goes farther bottom
                Spacer(minLength: 0)
                
                // MARK: - START / PAUSE / CONTINUE
                PrimaryButton(
                    title: timerEngine.isFinished ? "انتهيت" :
                        !hasStarted ? "ابدأ" :
                        timerEngine.isRunning ? "إيقاف مؤقت" :
                        "أكمل"
                ) {
                    if timerEngine.isFinished {
                        isDone = true
                        dismiss()
                    } else if !hasStarted {
                        hasStarted = true
                        timerEngine.start()
                    } else if timerEngine.isRunning {
                        timerEngine.pause()
                    } else {
                        timerEngine.resume()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    gamingDoView()
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}
