
import SwiftUI

/// Displays a gaming Create activity and its instructions.
struct gamingCreateView: View {

    // MARK: - State

    @StateObject private var viewModel: GamingCreateViewModel
    @State private var didFinish = false

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - Initialization

    init(activityID: String? = nil) {
        _viewModel = StateObject(
            wrappedValue: GamingCreateViewModel(activityID: activityID)
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header

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

                // MARK: Activity Title

                Text(viewModel.title)
                    .font(.supTitle1)
                    .foregroundStyle(Color.textPrimary)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.bottom, Spacing.space12)

                // MARK: Illustration

                Image(.gameIlllustration1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )
                    .padding(.bottom, Spacing.space16)
                    .padding(.top, Spacing.space16)

                // MARK: Materials

                CreateMaterialsView(
                    materials: viewModel.materials
                )
                .padding(.bottom, Spacing.space32)

                // MARK: Instructions

                ScrollView(showsIndicators: false) {
                    DoStepsCard(
                        howTo: viewModel.steps,
                        stepRingColor: Color.mapSequers
                    )
                    .padding(.horizontal, Spacing.pageMargin)
                    .padding(.bottom, Spacing.space32)
                }

                Spacer(minLength: 0)

                // MARK: Finish Button

                PrimaryButton(title: "اتمام التحدي") {
                    finishActivity()
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading
        )
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Completion

    /// Records the activity once and closes the screen.
    private func finishActivity() {
        guard !didFinish else {
            return
        }

        didFinish = true

        StorageService().recordCompletedActivity(
            interest: .gaming
        )

        dismiss()
    }
}

// MARK: - Materials Component

/// Displays the materials needed for a Create activity.
struct CreateMaterialsView: View {

    let materials: [String]

    // MARK: - Material Icons

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

    // MARK: - Body

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: Spacing.space12
        ) {
            Text("جهّز أدواتك")
                .font(.supTitle2)
                .foregroundStyle(Color.textPrimary)

            HStack(spacing: 12) {
                ForEach(materials, id: \.self) { material in
                    VStack(spacing: 8) {

                        Image(
                            systemName: materialIcon(for: material)
                        )
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
                            .frame(
                                height: 34,
                                alignment: .top
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 6)
                    .background(Color.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
                    .shadow(
                        color: .black.opacity(0.12),
                        radius: 12,
                        x: 0,
                        y: 8
                    )
                }
            }
        }
        .padding(.horizontal, Spacing.pageMargin)
    }
}

