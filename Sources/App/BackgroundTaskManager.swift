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
            if #available(iOS 16.2, *) {
                // New API on iOS 16.2+
                activity = try Activity.request(
                    attributes: attributes,
                    content: ActivityContent(state: initialState, staleDate: nil)
                )
            } else {
                // Fallback for iOS 16.1 and below
                activity = try Activity.request(
                    attributes: attributes,
                    contentState: initialState
                )
            }
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
            if #available(iOS 16.2, *) {
                await activity.end(
                    ActivityContent(state: .init(progress: progress), staleDate: nil),
                    dismissalPolicy: .immediate
                )
            } else {
                await activity.end(using: .init(progress: progress), dismissalPolicy: .immediate)
            }
            timer?.invalidate()
            timer = nil
            self.activity = nil
        } else {
            if #available(iOS 16.2, *) {
                await activity.update(
                    ActivityContent(
                        state: .init(progress: progress),
                        staleDate: nil
                    )
                )
            } else {
                await activity.update(using: .init(progress: progress))
            }
        }
    }
}
