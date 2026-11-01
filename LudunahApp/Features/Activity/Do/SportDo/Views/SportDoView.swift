
import SwiftUI

struct SportDoView: View {

    // MARK: - State

    @StateObject private var viewModel: SportDoViewModel
    @State private var didFinish = false

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - Initialization

    // activityID: النشاط المختار من الهوم
    init(activityID: String? = nil) {
        _viewModel = StateObject(
            wrappedValue: SportDoViewModel(activityID: activityID)
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: - Header

                ActivityHeader(
                    interestTitle: "الرياضة",
                    interestColor: .sportTint,
                    stepTitle: "طبّق",
                    stepIcon: "figure.soccer",
                    onBack: {
                        dismiss()
                    }
                )

                if let exercise = viewModel.currentExercise {

                    // MARK: - Exercise Content

                    ScrollView(showsIndicators: false) {
                        VStack(
                            alignment: .leading,
                            spacing: Spacing.space24
                        ) {
                            Text(exercise.title)
                                .font(.title1Heading)
                                .foregroundStyle(Color.textPrimary)
                                .multilineTextAlignment(.leading)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                                .padding(.top, Spacing.space32)

                            exerciseIllustration(for: exercise)

                            Text(
                                exercise.howTo?.joined(separator: " ") ?? ""
                            )
                            .font(.supTitle2)
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(Spacing.space4)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        }
                        .padding(.top, Spacing.space8)
                        .padding(.bottom, Spacing.space24)
                    }

                    Spacer(minLength: Spacing.space16)

                    // MARK: - Finish Button

                    PrimaryButton(title: "اتمام التحدي") {
                        finishActivity()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, Spacing.space24)

                } else {

                    // MARK: - Empty State

                    Spacer()

                    Text("ما فيه تمارين متاحة حاليًا")
                        .font(.supTitle2)
                        .foregroundStyle(Color.textPrimary)

                    Spacer()
                }
            }
            .padding(.horizontal, Spacing.pageMargin)
            .padding(.top, Spacing.space8)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    // MARK: - Exercise Illustration

    private func exerciseIllustration(
        for exercise: Activity
    ) -> some View {

        let imageName: String

        switch exercise.id {
        case "sport-do-1":
            imageName = "football"

        case "sport-do-2":
            imageName = "dribbling"

        case "sport-do-3", "sport-do-4":
            // مؤقتًا: صورة كرة القدم حتى تُضاف صور خاصة
            imageName = "football"

        default:
            imageName = "football"
        }

        return GeometryReader { geometry in
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                .clipped()
        }
        .aspectRatio(354.0 / 236.0, contentMode: .fit)
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 18,
            x: 0,
            y: 8
        )
    }

    // MARK: - Completion

    /// Records the completed sport activity only once.
    private func finishActivity() {
        guard !didFinish,
              viewModel.currentExercise != nil else {
            return
        }

        didFinish = true

        StorageService().recordCompletedActivity(
            interest: .sport
        )

        dismiss()
    }
}

// MARK: - Preview

#Preview {
    SportDoView()
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}
