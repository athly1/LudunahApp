// TaskSheet.swift - one sheet that takes an Interest.
//
// Contains:
// - One View for all interests. The Interest is passed in.
// - Shows today's task: title, description, minutes.
// - PrimaryButton "ابدأ" that opens ActivityFlowView through AppRouter.
//
// Used by: HomeView with .sheet(item:).


import SwiftUI

struct TaskSheet: View {
    let task: DailyTask
    let step: ActivityStep

    @Environment(AppRouter.self) private var appRouter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space24) {

            // العنوان وزر الإغلاق
            HStack {
                Text("تحدياتك")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.textPrimary)
                }
            }

            // تفاصيل النشاط
            VStack(alignment: .leading, spacing: Spacing.space16) {
                Text(task.title)
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)

                HStack {
                    Text(task.interest.title)
                    Spacer()
                    Text(step.title)
                }
                .font(.titleCards)
                .foregroundStyle(Color.appSecondary)

                if let minutes = task.minutes {
                    Label("\(minutes) دقائق", systemImage: "clock")
                        .font(.titleCards)
                        .foregroundStyle(Color.textPrimary)
                }

                if let description = task.description,
                   !description.isEmpty {
                    Text(description)
                        .font(.titleCards)
                        .foregroundStyle(Color.textPrimary)
                }

                if let skills = task.skills, !skills.isEmpty {
                    Text("إيش راح تطوّر؟")
                        .font(.titleCards)
                        .foregroundStyle(Color.textPrimary)

                    ForEach(skills, id: \.self) { skill in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle")
                            Text(skill)
                        }
                        .font(.titleCards)
                        .foregroundStyle(Color.appSecondary)
                    }
                }
            }

            Spacer(minLength: 0)

            PrimaryButton(title: "ابدأ التحدي") {
                appRouter.push(.activity(task.interest))
                dismiss()
            }
        }
        .padding(Spacing.pageMargin)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pageBackground.ignoresSafeArea())
        .environment(\.layoutDirection, .rightToLeft)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
