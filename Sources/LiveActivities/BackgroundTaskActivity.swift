import ActivityKit
import Foundation

// Defines the Live Activity's attributes and dynamic state
struct BackgroundTaskAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        /// Progress from 0.0 to 1.0
        var progress: Double
    }

    /// Name of the task being processed
    var taskName: String
}
