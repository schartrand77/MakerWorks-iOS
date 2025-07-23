import ActivityKit
import Foundation

/// Attributes for the processing Live Activity.
struct ProcessingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        /// Progress from 0.0 to 1.0
        var progress: Double
    }

    /// Name of the task (rendering, uploading, etc.)
    var taskName: String
}
