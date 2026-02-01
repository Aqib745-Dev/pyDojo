import SwiftUI

struct RootView: View {
    @EnvironmentObject var vm: AppVM
    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        TabView {
            SkillTreeView().tabItem { Label("Train", systemImage: "map") }
            ProjectsView().tabItem { Label("Projects", systemImage: "hammer") }
            StreakView().tabItem { Label("Streak", systemImage: "flame.fill") }
            SettingsView().tabItem { Label("Settings", systemImage: "gear") }
        }
        .tint(theme.accent)
    }
}
