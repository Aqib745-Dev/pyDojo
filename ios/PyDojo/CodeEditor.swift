import SwiftUI

struct CodeEditor: View {
    @EnvironmentObject var vm: AppVM
    @Binding var text: String
    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        TextEditor(text: $text)
            .font(.system(.body, design: .monospaced))
            .padding(12)
            .frame(minHeight: 220)
            .scrollContentBackground(.hidden)
            .background(RoundedRectangle(cornerRadius: 16).fill(theme.codeBackground))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(theme.text.opacity(0.12), lineWidth: 1))
    }
}
