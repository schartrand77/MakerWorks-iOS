import SwiftUI

struct LiquidGlassModifier: ViewModifier {
    var cornerRadius: CGFloat = 12
    var shadowRadius: CGFloat = 1
    var padding: CGFloat = 12

    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(colorScheme == .dark ? 0.15 : 0.3), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.2), radius: shadowRadius, x: 0, y: 1)
    }
}

extension View {
    func liquidGlass(cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 1, padding: CGFloat = 12) -> some View {
        modifier(
            LiquidGlassModifier(
                cornerRadius: cornerRadius,
                shadowRadius: shadowRadius,
                padding: padding
            )
        )
    }
}
