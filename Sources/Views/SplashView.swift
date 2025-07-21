import SwiftUI

struct SplashView: View {
    @State private var animate = false
    var onFinished: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            PixelNozzleAnimation(animate: $animate)
                .frame(width: 80, height: 80)
        }
        .onAppear {
            animate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                onFinished()
            }
        }
    }
}

struct PixelNozzleAnimation: View {
    @Binding var animate: Bool

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let nozzleSize = width * 0.25
            let filamentHeight = width * 0.1
            let travel = width - nozzleSize

            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: animate ? travel : 0, height: filamentHeight)
                    .offset(x: 0, y: nozzleSize + 4)
                    .animation(.linear(duration: 5), value: animate)

                Rectangle()
                    .fill(Color.gray)
                    .frame(width: nozzleSize, height: nozzleSize)
                    .offset(x: animate ? travel : 0)
                    .animation(.linear(duration: 5), value: animate)
            }
        }
    }
}

#Preview {
    SplashView(onFinished: {})
}
