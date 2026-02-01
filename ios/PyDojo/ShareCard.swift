import SwiftUI

struct StreakShareView: View {
    @EnvironmentObject var vm: AppVM
    var body: some View {
        let card = StreakShareCard(streakDays: vm.progress.streakDays, belt: vm.unlockedBelt(), tagline: AppConfig.tagline)
        VStack(spacing: 16) {
            card.padding()
            if let image = render(card: card) {
                ShareLink(item: Image(uiImage: image),
                          preview: SharePreview("My PyDojo streak", image: Image(uiImage: image))) {
                    Text("Share").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            } else {
                Text("Rendering share card…")
            }
            Spacer()
        }
        .navigationTitle("Share")
        .padding(.top, 8)
    }
    private func render(card: some View) -> UIImage? {
        let renderer = ImageRenderer(content: card.frame(width: 340, height: 220))
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}

struct StreakShareCard: View {
    let streakDays: Int
    let belt: Belt
    let tagline: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.linearGradient(colors: [.black, .blue.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(.white.opacity(0.15))
                    Image(systemName: "figure.martial.arts")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                }.frame(width: 64, height: 64)
                VStack(alignment: .leading, spacing: 6) {
                    Text("🔥 \(streakDays)-Day Python Streak").font(.headline).foregroundStyle(.white)
                    Text(belt.title).font(.subheadline).foregroundStyle(.white.opacity(0.85))
                    Text(tagline).font(.caption).foregroundStyle(.white.opacity(0.75))
                }
                Spacer()
            }
            .padding(18)
        }
        .frame(height: 220)
        .shadow(radius: 12)
    }
}
