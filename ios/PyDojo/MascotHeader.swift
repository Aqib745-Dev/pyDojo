import SwiftUI

struct MascotHeader: View {
    @EnvironmentObject var vm: AppVM
    let title: String
    let subtitle: String

    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        HStack(spacing: 12) {
            NinjaAvatar().frame(width: 52, height: 52)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(theme.text.opacity(0.75))
            }
            Spacer()
        }
        .padding()
        .background(theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct NinjaAvatar: View {
    @EnvironmentObject var vm: AppVM
    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        ZStack {
            Circle().fill(theme.accent.opacity(0.15))
            Image(systemName: "figure.martial.arts")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(theme.accent)
        }
    }
}
