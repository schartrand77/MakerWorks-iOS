import SwiftUI

struct LiquidGlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(radius: 1)
    }
}

extension View {
    func liquidGlass() -> some View {
        modifier(LiquidGlassModifier())
    }
}
