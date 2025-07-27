//
//  BackgroundTaskAttributes.swift
//  MakerWorksShared
//
//  Created by Stephen Chartrand on 2025-07-27.
//

#if canImport(ActivityKit)
import ActivityKit

/// Attributes for the background task live activity.
/// Shared between the main app and the widget extension.
struct BackgroundTaskAttributes: ActivityAttributes {
    /// Dynamic state for the live activity that updates over time.
    public struct ContentState: Codable, Hashable {
        /// Progress value between 0.0 and 1.0
        public var progress: Double

        public init(progress: Double) {
            self.progress = progress
        }
    }

    /// Static properties of the activity that do not change during its lifetime.
    public var jobName: String

    public init(jobName: String) {
        self.jobName = jobName
    }
}
#endif
