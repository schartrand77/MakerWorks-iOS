import SwiftUI

/// Demonstrates starting and stopping a Live Activity using ``ActivityManager``.
struct ContentView: View {
    @State private var isProcessing = false
    @State private var gearAngle = 0.0

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gearshape.fill")
                .rotationEffect(.degrees(gearAngle))
                .opacity(isProcessing ? 1 : 0)
                .animation(
                    isProcessing ? .linear(duration: 1).repeatForever(autoreverses: false) : .default,
                    value: gearAngle
                )

            Button(isProcessing ? "Stop Processing" : "Start Processing") {
                if isProcessing {
                    ActivityManager.shared.stop()
                    isProcessing = false
                } else {
                    ActivityManager.shared.startProcessing(taskName: "Upload")
                    isProcessing = true
                    startGearAnimation()
                }
            }
        }
        .padding()
    }

    private func startGearAnimation() {
        gearAngle = 0
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
            gearAngle = 360
        }
    }
}

#Preview {
    ContentView()
}
