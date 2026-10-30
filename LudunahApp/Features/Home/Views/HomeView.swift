import SwiftUI

struct HomeView: View {

    @Environment(AppRouter.self) private var appRouter

    @State private var energyValue = 50

    // النشاط البديل لكل بطاقة
    @State private var alternateActivities: [Int: Activity] = [:]

    // التحدي الذي تم الضغط عليه (يفتح InstructionsSheet)
    @State private var selectedChallenge: ChallengeSheetItem?

    // رسائل الخطأ
    @State private var showSwapError = false
    @State private var swapErrorMessage = ""

    var body: some View {
        ScrollView {
            Spacer(minLength: -32)
            
            VStack(alignment: .leading, spacing: Spacing.space24) {

                // الإعدادات - أعلى اليمين
                HStack {
                    Button {
                        appRouter.push(.settings)
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.textPrimary)
                            .frame(width: 35, height: 44)
                            .contentShape(Circle())
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel("الإعدادات")

                    Spacer()
                }

                // مستوى الطاقة
                EnergyCheckInView(
                    energyValue: $energyValue
                )

                // عنوان التحديات
                Text("تحدياتك")
                    .font(.title1Heading)
                    .foregroundStyle(Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // التحدي الأول: الفن
                DailyChallengeCard(
                    title: alternateActivities[1]?.title
                        ?? "التكوين البصري الصامت",
                    category: "الفن السعودي",
                    minutes: alternateActivities[1]?.durationMin ?? 5,
                    isCompleted: appRouter.completedInterests.contains(.art),                    iconName: "artLudunah",
                    iconBackground: Color.challengeArtBadge,
                    onSwap: {
                        swapChallenge(
                            id: 1,
                            interest: .art,
                            originalTitle: "التكوين البصري الصامت"
                        )
                    },
                    onTap: {
                        showInstructions(
                            id: 1,
                            interest: .art,
                            image: "artLudunah",
                            defaultTitle: "التكوين البصري الصامت"
                        )
                    }                )

                // التحدي الثاني: الألعاب
                DailyChallengeCard(
                    title: alternateActivities[2]?.title
                        ?? "خريطة اللعبة في رأسك",
                    category: "الرياضات الإلكترونية",
                    minutes: alternateActivities[2]?.durationMin ?? 5,
                    isCompleted: appRouter.completedInterests.contains(.gaming),                    iconName: "GameLudunah",
                    iconBackground: Color.challengeGamingBadge,
                    onSwap: {
                        swapChallenge(
                            id: 2,
                            interest: .gaming,
                            originalTitle: "خريطة اللعبة في رأسك"
                        )
                    },
                    onTap: {
                        showInstructions(
                            id: 2,
                            interest: .gaming,
                            image: "GameLudunah",
                            defaultTitle: "خريطة اللعبة في رأسك"
                        )
                    }
                )

                // التحدي الثالث: الرياضة
                DailyChallengeCard(
                    title: alternateActivities[3]?.title
                        ?? "الجدران جزء من اللعبة",
                    category: "كرة القدم",
                    minutes: alternateActivities[3]?.durationMin ?? 8,
                    isCompleted: appRouter.completedInterests.contains(.sport),                   iconName: "SportLudunah",
                    iconBackground: Color.challengeSportBadge,
                    onSwap: {
                        swapChallenge(
                            id: 3,
                            interest: .sport,
                            originalTitle: "الجدران جزء من اللعبة"
                        )
                    },
                    onTap: {
                        showInstructions(
                            id: 3,
                            interest: .sport,
                            image: "SportLudunah",
                            defaultTitle: "الجدران جزء من اللعبة"
                        )
                    }
                )
            }
            .padding(Spacing.pageMargin)
        }
        .background(Color.pageBackground.ignoresSafeArea())
        .environment(\.layoutDirection, .rightToLeft)
        .toolbar(.hidden, for: .navigationBar)

        // تحديث التحديات عند الانتقال إلى مستوى طاقة آخر
        .onChange(of: EnergyLevel.from(value: energyValue)) { _, _ in
            swapChallenge(
                id: 1,
                interest: .art,
                originalTitle: "التكوين البصري الصامت"
            )

            swapChallenge(
                id: 2,
                interest: .gaming,
                originalTitle: "خريطة اللعبة في رأسك"
            )

            swapChallenge(
                id: 3,
                interest: .sport,
                originalTitle: "الجدران جزء من اللعبة"
            )
        }

        // بطاقة تعليمات التحدي (بعرض الشاشة كاملًا)
        .overlay {
            if let item = selectedChallenge {
                ZStack(alignment: .bottom) {

                    // خلفية معتمة، الضغط عليها يغلق البطاقة
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .onTapGesture { closeInstructions() }

                    InstructionsSheet(
                        interest: item.interest,
                        InterestImage: item.image,
                        activity: item.activity,
                        onClose: { closeInstructions() }
                    )
                    .id(item.id)
                    .frame(maxWidth: .infinity)
                    .containerRelativeFrame(.vertical) { height, _ in
                        height * 0.65
                    }
                    .background(
                        Color.pageBackground,
                        in: UnevenRoundedRectangle(
                            topLeadingRadius: 32,
                            topTrailingRadius: 32
                        )
                    )
                    .ignoresSafeArea(edges: .bottom)
                    .transition(.move(edge: .bottom))
                }
            }
        }

        // عرض رسائل الخطأ
        .alert(
            "تعذّر تبديل التحدي",
            isPresented: $showSwapError
        ) {
            Button("حسنًا", role: .cancel) {}
        } message: {
            Text(swapErrorMessage)
        }
    }

    // إغلاق بطاقة التعليمات والرجوع للهوم
    private func closeInstructions() {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedChallenge = nil
        }
    }

    // فتح شيت التعليمات للتحدي المعروض على البطاقة
    private func showInstructions(
        id: Int,
        interest: Interest,
        image: String,
        defaultTitle: String
    ) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedChallenge = ChallengeSheetItem(
                interest: interest,
                image: image,
                activity: currentActivity(
                    id: id,
                    interest: interest,
                    defaultTitle: defaultTitle
                )
            )
        }
    }

    // النشاط المعروض الآن على البطاقة
    private func currentActivity(
        id: Int,
        interest: Interest,
        defaultTitle: String
    ) -> Activity? {

        // 1. النشاط البديل بعد التبديل
        if let swapped = alternateActivities[id] {
            return swapped
        }

        let all = (try? ContentService.loadActivities(for: interest)) ?? []

        // 2. النشاط الافتراضي حسب العنوان
        if let match = all.first(where: { $0.title == defaultTitle }) {
            return match
        }

        // 3. أول نشاط يناسب مستوى الطاقة
        let step = EnergyLevel.from(value: energyValue).activityStep
        return all.first(where: { $0.type == step })
    }

    // اختيار تحدٍ عشوائي من الفئة نفسها حسب مستوى الطاقة
    private func swapChallenge(
        id: Int,
        interest: Interest,
        originalTitle: String
    ) {
        let requiredStep = EnergyLevel
            .from(value: energyValue)
            .activityStep

        do {
            let activities = try ContentService
                .loadActivities(for: interest)
                .filter { $0.type == requiredStep }

            let currentTitle = alternateActivities[id]?.title
                ?? originalTitle

            let alternatives = activities.filter {
                $0.title != currentTitle
            }

            guard let selected = alternatives.randomElement() else {
                swapErrorMessage =
                    "لا يوجد تحدٍ بديل مناسب لمستوى طاقتك في هذه الفئة."
                showSwapError = true
                return
            }

            alternateActivities[id] = selected
            
            appRouter.resetCompletion(interest)
            
            appRouter.resetCompletion(interest)
        } catch {
            swapErrorMessage =
                "تعذّر تحميل الأنشطة. تحققي من ملفات JSON."
            showSwapError = true
        }
    }
}

// بيانات الشيت المفتوح من البطاقة
struct ChallengeSheetItem: Identifiable {
    let id = UUID()
    let interest: Interest
    let image: String
    let activity: Activity?
}

#Preview {
    HomeView()
        .environment(AppRouter())
}
