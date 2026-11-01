
import SwiftUI

struct SportDoView: View {
    @StateObject private var viewModel: SportDoViewModel
    @State private var didFinish = false

    @Environment(\.dismiss) private var dismiss

    init(activityID: String? = nil) {
        _viewModel = StateObject(
            wrappedValue: SportDoViewModel(activityID: activityID)
        )
    }

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ActivityHeader(
                    interestTitle: "الرياضة",
                    interestColor: .sportTint,
                    stepTitle: "طبّق",
                    stepIcon: "figure.soccer",
                    onBack: { dismiss() }
                )

                if let exercise = viewModel.currentExercise {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: Spacing.space24) {
                            Text(exercise.title)
                                .font(.title1Heading)
                                .foregroundStyle(Color.textPrimary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, Spacing.space32)

                            exerciseIllustration(for: exercise)

                            Text(exercise.howTo?.joined(separator: " ") ?? "")
                                .font(.supTitle2)
                                .foregroundStyle(Color.textPrimary)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(Spacing.space4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.top, Spacing.space8)
                        .padding(.bottom, Spacing.space24)
                    }

                    Spacer(minLength: Spacing.space16)

                    PrimaryButton(title: "انتهيت") {
                        finishActivity()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, Spacing.space24)
                } else {
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

    private func exerciseIllustration(for exercise: Activity) -> some View {
        let imageName: String

        switch exercise.id {
        case "sport-do-1":
            imageName = "football"
        case "sport-do-2":
            imageName = "dribbling"
        default:
            imageName = "football"
        }

        return Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .aspectRatio(354.0 / 236.0, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 8)
    }

    private func finishActivity() {
        guard !didFinish, viewModel.currentExercise != nil else { return }

        didFinish = true
        StorageService().recordCompletedActivity(interest: .sport)
        dismiss()
    }
}

#Preview {
    SportDoView()
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}

