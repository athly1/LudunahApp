
import SwiftUI

/// Displays activity completion counts for the last seven days.
/// Uses custom SwiftUI bars and shows the count for each day.
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

            HStack(alignment: .bottom, spacing: 8) {
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

    private func dayColumn(for day: DayProgress) -> some View {
        VStack(spacing: 8) {

            Spacer(minLength: 0)

            if day.count == 0 {
                Capsule()
                    .fill(Color.textPrimary.opacity(0.08))
                    .frame(height: 7)
            } else {
                Text("\(day.count)")
                    .font(.caption)
                    .foregroundStyle(Color.textPrimary)

                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        Color(
                            red: 0.76,
                            green: 0.84,
                            blue: 0.89
                        )
                    )
                    .frame(height: barHeight(for: day.count))
            }

            Text(shortDayName(for: day.date))
                .font(.caption)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
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
        let maxHeight: CGFloat = 110
        let minHeight: CGFloat = 24

        let ratio = CGFloat(count) / CGFloat(maximumCount)

        return max(minHeight, maxHeight * ratio)
    }

    // MARK: - Day Names

    private func shortDayName(for date: Date) -> String {
        let calendar = Calendar.current

        switch calendar.component(.weekday, from: date) {
        case 1: return "أحد"
        case 2: return "إثن"
        case 3: return "ثلا"
        case 4: return "أرب"
        case 5: return "خمي"
        case 6: return "جمع"
        case 7: return "سبت"
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
