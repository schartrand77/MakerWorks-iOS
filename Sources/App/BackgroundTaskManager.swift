import ActivityKit
import Foundation
import SwiftUI

/// Manages a background task and updates the Live Activity with progress.
@MainActor
final class BackgroundTaskManager: ObservableObject {
    private var activity: Activity<BackgroundTaskAttributes>?
    private var timer: Timer?
    private var progress: Double = 0

    /// Starts a simulated background task and Live Activity updates.
    func start() {
        let attributes = BackgroundTaskAttributes(taskName: "Processing")
        let initialState = BackgroundTaskAttributes.ContentState(progress: 0)

        do {
            activity = try Activity.request(attributes: attributes, contentState: initialState)
            startTimer()
        } catch {
            print("Failed to start activity: \(error)")
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { await self?.incrementProgress() }
        }
    }

    private func incrementProgress() async {
        guard let activity else { return }
        progress += 0.02
        if progress >= 1 {
            progress = 1
            await activity.end(using: .init(progress: progress), dismissalPolicy: .immediate)
            timer?.invalidate()
            timer = nil
            self.activity = nil
        } else {
            await activity.update(using: .init(progress: progress))
        }
    }
}
