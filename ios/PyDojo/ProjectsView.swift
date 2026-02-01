import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var vm: AppVM
    private let projects: [String] = ["Password Generator","Expense Tracker","File Organizer","API Weather CLI","Log Analyzer","To‑Do CLI","Quiz Game","Web Scraper","Text Cleaner","Mini Chatbot"]
    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        NavigationStack {
            List {
                Section {
                    MascotHeader(title: "Projects", subtitle: "Unlocked by belts • Build real tools")
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                }
                ForEach(projects, id: \ .self) { p in
                    HStack { Text(p); Spacer(); Image(systemName:"chevron.right").foregroundStyle(theme.text.opacity(0.5)) }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Projects")
        }
    }
}
