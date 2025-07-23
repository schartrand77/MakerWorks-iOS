import SwiftUI

/// Demonstrates starting a background task with a Live Activity.
struct ContentView: View {
    @StateObject private var taskManager = BackgroundTaskManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, MakerWorks!")
            Button("Start Background Task") {
                taskManager.start()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
