
import SwiftUI

struct InstructionsSheet: View {
    
    @ViewBuilder
    private var activityDestination: some View {
        if let activity = viewModel.activity {
            switch viewModel.interest {
            case .gaming:
                switch activity.type {
                case .learn:
                    gameLearnView()
                case .doActivity:
                    gamingDoView()
                case .create:
                    gamingCreateView()
                }

            case .art, .sport:
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }

    

    // Image passed from Home.
    var InterestImage: String
    
    // Controls whether the activity screen is presented.
     @State private var showActivity = false
    
    // Receive activity data from the ViewModel.
    @StateObject private var viewModel: InstructionsSheetViewModel

    init(interest: Interest, InterestImage:String ) {
        self.InterestImage = InterestImage

        _viewModel = StateObject(
            wrappedValue: InstructionsSheetViewModel(interest: interest)
        )
    }
    
    var body: some View {

        ZStack {

            Color.pageBackground
                .ignoresSafeArea()

                // Bottom sheet.
                .sheet(isPresented: .constant(true)) {

                    VStack(spacing: 0) {

                        // MARK: - Header
                        HStack(spacing: Spacing.space12) {

                            Image(InterestImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 52, height: 52)

                            VStack(alignment: .leading,
                                   spacing: Spacing.space4) {

                                Text(viewModel.title)
                                    .font(.popupTitle)
                                    .foregroundColor(.textPrimary)

                                HStack(spacing: Spacing.space4) {
                                    Text(viewModel.duration)
                                        .font(.titleCards)
                                        .foregroundColor(.textPrimary)
                                        .padding(.horizontal, Spacing.space12)
                                        .frame(height: Spacing.chipHeight)
                                        .background(Color.actionPrimary)
                                        .cornerRadius(999)

                                    Text(viewModel.interestTitle)
                                        .font(.titleCards)
                                        .foregroundColor(.textPrimary)
                                        .padding(.horizontal, Spacing.space12)
                                        .frame(height: Spacing.chipHeight)
                                        .background(viewModel.interestColor)
                                        .cornerRadius(999)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // MARK: - Description
                        Text(viewModel.description)
                            .font(.titleCards)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, Spacing.space24)

                        // MARK: - Challenge information card
                        VStack(alignment: .leading, spacing: Spacing.space12) {

                            Text("فئة التحدي")
                                .font(.popupTitle)
                                .foregroundColor(.textPrimary)

                            InfoCardinSheet(
                                title: viewModel.typeTitle,
                                info: viewModel.description,
                                icon: viewModel.infoIcon
                            )
                        }
                        .padding(.top, Spacing.space24)
                        

                        // MARK: - Skills chips
                        VStack(alignment: .leading, spacing: Spacing.space12) {

                            Text("ماذا ستتدرب؟")
                                .font(.popupTitle)
                                .foregroundColor(.textPrimary)

                            // Skills from the selected activity.
                            SetOfShips(skills: viewModel.skills)
                        }
                        .padding(.top, Spacing.space24)
                        

                        Spacer(minLength: 0)

                        
                            // MARK: - Start button
                            PrimaryButton(title: "ابدأ التحدي") {
                                showActivity = true
                            }
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.pageBackground)

                    // Bottom-sheet height.
                    .presentationDetents([.fraction(0.65)])
                    .presentationDragIndicator(.visible)
                    .environment(\.layoutDirection, .rightToLeft)
                    .fullScreenCover(isPresented: $showActivity) {
                        activityDestination
                    }
                }
        }
    }
}

// MARK: - Information Card
struct InfoCardinSheet: View {

    let title: String
    let info: String
    let icon: String

    var body: some View {

        HStack(spacing: Spacing.space12) {

            Image(systemName: icon)
                .foregroundColor(.textPrimary)
                .padding(8)
                .background(Color.actionPrimary)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.supTitle1)
                    .foregroundStyle(Color.textPrimary)

                Text(info)
                    .font(.titleCards)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Skills Chips
struct SetOfShips: View {

    var skills: [String]

    var body: some View {

        HStack(spacing: Spacing.space4) {

            ForEach(skills, id: \.self) { skill in

                Text(skill)
                    .font(.titleCards)
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, Spacing.space12)
                    .frame(height: Spacing.chipHeight)
                    .background(Color.white)
                    .cornerRadius(999)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)

    }
    
}


#Preview {
    
    //called at home
    InstructionsSheet(interest: .gaming, InterestImage: "GameLudunah" )
        .environment(\.layoutDirection, .rightToLeft)
}



