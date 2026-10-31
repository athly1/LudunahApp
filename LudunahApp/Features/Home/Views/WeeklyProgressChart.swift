// WeeklyProgressChart.swift - completed activities for the last 7 days.
//
// Contains:
// - A bar chart: day on the x axis, count on the y axis.
// - Input: list of day + count values from HomeViewModel.
// - Empty state when there is no progress.
//
// Used by: HomeView.
// Learn: Swift Charts (Chart, BarMark)



import SwiftUI

/// Displays real activity completion counts for the last seven days.
struct WeeklyProgressChart: View {

    let counts: [Int]

    // MARK: - Model

    private struct DayProgress: Identifiable {
        let date: Date
        let count: Int

        var id: Date { date }
    }

    // MARK: - Data

    private var days: [DayProgress] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (0..<7).compactMap { index in
            guard let date = calendar.date(
                byAdding: .day,
                value: index - 6,
                to: today
            ) else {
                return nil
            }

            let count = counts.indices.contains(index)
                ? max(0, counts[index])
                : 0

            return DayProgress(date: date, count: count)
        }
    }

    private var maximumCount: Int {
        max(days.map(\.count).max() ?? 0, 1)
    }

    private var monthTitle: String {
        Date().formatted(
            .dateTime
                .month(.wide)
                .locale(Locale(identifier: "ar_SA"))
        )
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            Text(monthTitle)
                .font(.titleCards)
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(alignment: .bottom, spacing: 12) {
                ForEach(days) { day in
                    dayColumn(for: day)
                }
            }
            .frame(height: 190)
        }
        .padding(Spacing.space24)
        .frame(maxWidth: .infinity)
        .background(
            Color.white,
            in: RoundedRectangle(cornerRadius: 28)
        )
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Day Column

    private func dayColumn(
        for day: DayProgress
    ) -> some View {

        VStack(spacing: 12) {

            Spacer(minLength: 0)

            if day.count == 0 {
                Capsule()
                    .fill(Color.textPrimary.opacity(0.08))
                    .frame(height: 7)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        Color(
                            red: 0.76,
                            green: 0.84,
                            blue: 0.89
                        )
                    )
                    .frame(
                        height: barHeight(for: day.count)
                    )
            }

            Text(shortDayName(for: day.date))
                .font(.supTitle2)
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "\(fullDayName(for: day.date)): \(day.count) نشاط مكتمل"
        )
    }

    // MARK: - Bar Height

    private func barHeight(for count: Int) -> CGFloat {
        let maxHeight: CGFloat = 130
        let minHeight: CGFloat = 24

        let ratio = CGFloat(count) / CGFloat(maximumCount)

        return max(
            minHeight,
            maxHeight * ratio
        )
    }

    // MARK: - Day Names

    private func shortDayName(for date: Date) -> String {
        let calendar = Calendar.current

        switch calendar.component(.weekday, from: date) {
        case 1: return "أ"  // Sunday
        case 2: return "إ"  // Monday
        case 3: return "ث"  // Tuesday
        case 4: return "ر"  // Wednesday
        case 5: return "خ"  // Thursday
        case 6: return "ج"  // Friday
        case 7: return "س"  // Saturday
        default: return ""
        }
    }

    private func fullDayName(for date: Date) -> String {
        date.formatted(
            .dateTime
                .weekday(.wide)
                .locale(Locale(identifier: "ar_SA"))
        )
    }
}
