import SwiftUI

struct gamingCreateView: View {

    @StateObject private var viewModel: GamingCreateViewModel

    // activityID: النشاط المختار من الهوم
    init(activityID: String? = nil) {
        _viewModel = StateObject(
            wrappedValue: GamingCreateViewModel(activityID: activityID)
        )
    }

    //Close the page
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {

        ZStack {

            Color.pageBackground
                .ignoresSafeArea()

            // The main page is a VStack
            VStack(spacing: 0) {

                // MARK: - header: back button + title + chips
                ActivityHeader(
                    interestTitle: "الألعاب الإلكترونية",
                    interestColor: .gamingChip,
                    stepTitle: "ابتكر",
                    stepIcon: "lasso.badge.sparkles",
                    onBack: {
                        dismiss()
                    }
                )
                .padding(.horizontal, Spacing.pageMargin)
                .padding(.bottom, Spacing.pageMargin)

                // MARK: - Title of today's Create
                Text(viewModel.title)
                    .font(.supTitle1)
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.bottom, Spacing.space12)

                // MARK: - Centered Illustration

                // resizable() allows the image to change size.
                // scaledToFit() preserves its original proportions.
                // A full-width frame with center alignment centers the image.
                Image(.gameIlllustration1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, Spacing.space16)
                    .padding(.top, Spacing.space16)

                // MARK: - Materials Needed

                CreateMaterialsView(materials: viewModel.materials)
                    .padding(.bottom, Spacing.space32)

                // MARK: - Steps to Create
                ScrollView(showsIndicators: false) {

                    DoStepsCard(
                        howTo: viewModel.steps,
                        stepRingColor: Color.mapSequers
                    )
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.bottom, Spacing.space32)
                }
                
                
                Spacer(minLength: 0)
                
                // MARK: - Done Button
                PrimaryButton(title: "انتهيت") {
                    dismiss()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .environment(\.layoutDirection, .rightToLeft)

    }
}


// MARK: -  Shows the materials needed for a Create activity.
struct CreateMaterialsView: View {

    // Materials supplied by the ViewModel.
    let materials: [String]

    // Select an icon for each material.
    private func materialIcon(for material: String) -> String {

        switch material {
        case "ورقة":
            return "doc.text"
        case "قلم":
            return "pencil.tip"
        case "مساحة اللعب":
            return "dpad"
        default:
            return "sparkles"
        }
    }

    var body: some View {

        VStack(alignment: .leading, spacing: Spacing.space12) {

            // MARK: - Title

            Text("جهّز أدواتك")
                .font(.supTitle2)
                .foregroundStyle(Color.textPrimary)

            // MARK: - Materials
            HStack(spacing: 12) {

                ForEach(materials, id: \.self) { material in

                    VStack(spacing: 8) {

                        Image(systemName: materialIcon(for: material))
                            .font(.title2)
                            .foregroundStyle(Color.mapSequers)
                            .frame(width: 32, height: 32)
                            .background(Color.gamingTint)
                            .clipShape(Circle())

                        Text(material)
                            .font(.caption)
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.85)
                            .frame(maxWidth: .infinity)
                            .frame(height: 34, alignment: .top)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 6)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 8)
                }
            }
        }
        .padding(.horizontal, Spacing.pageMargin)
    }
}



/// TEST ONLY
struct TestCreateNavigation: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Test Create Activity") {
                gamingCreateView()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}

#Preview {

    TestCreateNavigation()
        
}

