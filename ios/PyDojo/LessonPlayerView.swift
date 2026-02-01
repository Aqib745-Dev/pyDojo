import SwiftUI

struct LessonPlayerView: View {
    @EnvironmentObject var vm: AppVM
    let lesson: Lesson

    @State private var index: Int = 0
    @State private var xpEarned: Int = 0

    @State private var maxDurability: Int = 5
    @State private var durability: Int = 5
    @State private var slashed: Bool = false
    @State private var feedback: String? = nil
    @State private var showComplete: Bool = false

    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        let ex = lesson.exercises[index]

        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                MascotHeader(title: lesson.title, subtitle: "\(lesson.belt.title) • Mission \(index+1)/\(lesson.exercises.count)")
                KatanaDurabilityBar(max: maxDurability, remaining: durability, slashed: slashed)

                ExerciseCard(exercise: ex, onResult: { ok, msg in
                    if ok { xpEarned += 5; feedback = "✅ " + msg; advance() }
                    else { feedback = "❌ " + msg; slash() }
                })

                if let feedback {
                    Text(feedback).font(.subheadline).bold()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(theme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                if showComplete { CompletionCard(xp: xpEarned, streak: vm.progress.streakDays) }
            }
            .padding()
        }
        .background(theme.background.ignoresSafeArea())
        .navigationTitle("Lesson")
        .onAppear {
            maxDurability = (lesson.belt >= .green) ? 3 : 5
            durability = maxDurability
        }
    }

    private func slash() {
        if durability > 0 { durability -= 1 }
        slashed = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { slashed = false }
        if durability == 0 {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            feedback = "🗡️ Durability broke. Quick recovery — retry this mission."
            durability = maxDurability
        }
    }

    private func advance() {
        if index < lesson.exercises.count - 1 { index += 1 }
        else { showComplete = true; vm.markLessonCompleted(lesson, awardedXP: xpEarned) }
    }
}

private struct CompletionCard: View {
    @EnvironmentObject var vm: AppVM
    let xp: Int
    let streak: Int
    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        VStack(alignment: .leading, spacing: 10) {
            Text("Mission complete").font(.headline)
            Text("XP earned: \(xp)")
            Text("Streak: \(streak) days").foregroundStyle(theme.text.opacity(0.8))
            NavigationLink { StreakShareView() } label: {
                Text("Share streak card").frame(maxWidth: .infinity)
            }.buttonStyle(.borderedProminent)
        }
        .padding()
        .background(theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
