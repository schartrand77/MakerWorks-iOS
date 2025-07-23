import ActivityKit
import Foundation

/// Singleton responsible for managing the processing Live Activity.
@MainActor
final class ActivityManager: ObservableObject {
    static let shared = ActivityManager()

    private var activity: Activity<ProcessingAttributes>?
    private var updateTask: Task<Void, Never>?
    private var progress: Double = 0

    private init() {}

    /// Starts the Live Activity and begins simulating progress updates.
    func startProcessing(taskName: String = "Processing") {
        guard activity == nil else { return }
        let attributes = ProcessingAttributes(taskName: taskName)
        let content = ProcessingAttributes.ContentState(progress: 0)

        do {
            activity = try Activity.request(attributes: attributes, contentState: content)
            startProgressLoop()
        } catch {
            print("Failed to start Live Activity: \(error)")
        }
    }

    /// Cancels progress updates and ends the Live Activity.
    func stop() {
        Task { await endActivity() }
    }

    /// Periodically increments progress to demonstrate updates.
    private func startProgressLoop() {
        updateTask?.cancel()
        updateTask = Task {
            while progress < 1.0 && !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                progress = min(progress + 0.05, 1)
                await activity?.update(using: .init(progress: progress))
            }
            if !Task.isCancelled {
                await endActivity()
            }
        }
    }

    private func endActivity() async {
        updateTask?.cancel()
        updateTask = nil
        if let activity {
            await activity.end(using: .init(progress: progress), dismissalPolicy: .immediate)
        }
        self.activity = nil
        progress = 0
    }
}
