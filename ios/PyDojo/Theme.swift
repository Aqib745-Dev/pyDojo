import SwiftUI

struct Theme {
    let style: ThemeStyle
    var background: Color { style == .darkPro ? .black : Color(.systemGroupedBackground) }
    var card: Color {
        switch style {
        case .cleanLight, .playful: return Color(.secondarySystemGroupedBackground)
        case .darkPro: return Color(.init(white: 0.12, alpha: 1.0))
        }
    }
    var text: Color { style == .darkPro ? .white : .primary }
    var accent: Color { style == .darkPro ? .cyan : (style == .playful ? .purple : .blue) }
    var codeBackground: Color { style == .darkPro ? Color(.init(white: 0.08, alpha: 1.0)) : Color(.secondarySystemGroupedBackground) }
}
