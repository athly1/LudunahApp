
// SettingsView.swift - شاشة الإعدادات في لُدُونه.
//
// Contains:
// - Custom header with back button.
// - Notifications toggle.
// - Interests selection (up to 3).
//
// Used by: AppRouter (.settings).
// Learn: @Environment, @AppStorage, Toggle, FlowLayout.

import SwiftUI

struct SettingsView: View {

    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    // حالة التنبيهات محفوظة محليًا
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false

    private let maxSelection = 3

    private let brown = Color(red: 0.42, green: 0.30, blue: 0.17)
    private let cardColor = Color(red: 0.99, green: 0.985, blue: 0.97)
    // #BFD2DE
    private let accent = Color(red: 191 / 255, green: 210 / 255, blue: 222 / 255)

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                header

                notificationsCard

                interestsCard
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color.pageBackground.ignoresSafeArea())
        // نستخدم زر رجوع مخصص بدل زر النظام
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
    }

    // MARK: - Header

    private var header: some View {

        ZStack {

            Text("الإعدادات")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(brown)

            // في RTL أول عنصر يكون على اليمين، فالزر قبل الـ Spacer
            HStack {

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(brown)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.glass)
                .clipShape(Circle())
                .accessibilityLabel("رجوع")

                Spacer()
            }
        }
        .frame(height: 56)
    }

    // MARK: - Notifications Card

    private var notificationsCard: some View {

        HStack(spacing: 12) {

            Image(systemName: "bell")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(brown)
                .frame(width: 36, height: 36)
                .background(accent, in: RoundedRectangle(cornerRadius: 9))

            Text("التنبيهات")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(brown)

            Spacer()

            Toggle("التنبيهات", isOn: $notificationsEnabled)
                .labelsHidden()
                .toggleStyle(.switch)
                .tint(accent)
        }
        .padding(20)
        .background(cardColor, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - Interests Card

    private var interestsCard: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                Text("الاهتمامات")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(brown)

                Spacer()

                Text("\(appState.selectedInterests.count) من \(maxSelection)")
                    .font(.system(size: 13))
                    .foregroundStyle(brown)
            }

            FlowLayout(spacing: 10) {

                ForEach(Interest.allCases) { interest in
                    SettingsInterestChip(
                        interest: interest,
                        isSelected: appState.selectedInterests.contains(interest),
                        brown: brown,
                        selectedColor: accent
                    ) {
                        toggle(interest)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(cardColor, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - Actions

    // إضافة أو حذف اهتمام مع حفظه مباشرة
    private func toggle(_ interest: Interest) {

        var interests = appState.selectedInterests

        if interests.contains(interest) {
            // لازم يبقى اهتمام واحد على الأقل
            guard interests.count > 1 else { return }
            interests.remove(interest)
        } else {
            guard interests.count < maxSelection else { return }
            interests.insert(interest)
        }

        withAnimation(.easeInOut(duration: 0.2)) {
            appState.updateInterests(interests)
        }
    }
}

// MARK: - Interest Chip

// كبسولة اهتمام: ممتلئة عند الاختيار، بإطار فقط عند عدم الاختيار
private struct SettingsInterestChip: View {

    let interest: Interest
    let isSelected: Bool
    let brown: Color
    let selectedColor: Color
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 6) {

                Image(systemName: interest.iconName)
                    .font(.system(size: 13))

                Text(interest.title)
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundStyle(brown)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                isSelected ? selectedColor : Color.white,
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .stroke(
                        isSelected ? Color.clear : Color.gray.opacity(0.35),
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(AppState())
    .environment(\.layoutDirection, .rightToLeft)
}
