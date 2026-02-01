import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: AppVM
    @State private var goal: Double = 5

    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        NavigationStack {
            Form {
                Section("Daily Goal") {
                    VStack(alignment: .leading) {
                        Text("Minutes per day: \(Int(goal))").font(.headline)
                        Slider(value: $goal, in: 3...30, step: 1)
                        Text("Tip: Start small. Consistency beats intensity.")
                            .font(.caption).foregroundStyle(theme.text.opacity(0.7))
                    }
                    .onChange(of: goal) { _, newValue in vm.setDailyGoalMinutes(Int(newValue)) }
                }
                Section("UI Theme") {
                    Picker("Theme", selection: $vm.themeStyle) {
                        Text("Clean Light").tag(ThemeStyle.cleanLight)
                        Text("Dark Pro").tag(ThemeStyle.darkPro)
                        Text("Playful").tag(ThemeStyle.playful)
                    }
                }
                Section("About") {
                    Text(AppConfig.tagline)
                    Text("Backend: \(AppConfig.API_BASE_URL.absoluteString)").font(.footnote)
                }
                Section {
                    Button(role: .destructive) { vm.resetAll(); goal = Double(vm.dailyGoalMinutes()) } label: { Text("Reset Progress") }
                }
            }
            .onAppear { goal = Double(vm.dailyGoalMinutes()) }
            .scrollContentBackground(.hidden)
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Settings")
        }
    }
}
