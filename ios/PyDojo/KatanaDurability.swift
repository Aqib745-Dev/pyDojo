import SwiftUI

struct KatanaDurabilityBar: View {
    @EnvironmentObject var vm: AppVM
    let max: Int
    let remaining: Int
    let slashed: Bool

    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Durability", systemImage: "sword").font(.caption).bold()
                Spacer()
                Text("\(remaining)/\(max)").font(.caption).foregroundStyle(theme.text.opacity(0.7))
            }
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10).fill(theme.text.opacity(0.10)).frame(height: 12)
                RoundedRectangle(cornerRadius: 10).fill(theme.accent.opacity(0.85))
                    .frame(width: max == 0 ? 0 : CGFloat(remaining) / CGFloat(max) * 240, height: 12)
                    .animation(.easeOut(duration: 0.25), value: remaining)
                if slashed { SlashOverlay().frame(height: 12).transition(.opacity) }
            }
            .frame(width: 240, height: 12)
        }
        .padding()
        .background(theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct SlashOverlay: View {
    var body: some View {
        GeometryReader { geo in
            Path { p in
                p.move(to: CGPoint(x: geo.size.width * 0.15, y: geo.size.height * 0.10))
                p.addLine(to: CGPoint(x: geo.size.width * 0.85, y: geo.size.height * 0.90))
            }
            .stroke(Color.red.opacity(0.8), lineWidth: 3)
        }
    }
}
