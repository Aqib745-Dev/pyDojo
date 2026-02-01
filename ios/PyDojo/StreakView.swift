import SwiftUI

struct StreakView: View {
    @EnvironmentObject var vm: AppVM
    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                MascotHeader(title: "Streak", subtitle: "Keep training. Discipline wins.")
                Text("🔥 \(vm.progress.streakDays) days").font(.system(size: 44, weight: .bold))
                Text("Daily goal: \(vm.dailyGoalMinutes()) minutes").foregroundStyle(theme.text.opacity(0.8))
                NavigationLink { StreakShareView() } label: {
                    Text("Share your streak").frame(maxWidth: .infinity)
                }.buttonStyle(.borderedProminent)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Streak")
        }
    }
}
