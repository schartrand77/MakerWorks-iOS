//
//  BackgroundTaskWidget.swift
//  MakerWorksWidgetExtension
//
//  Created by Stephen Chartrand on 2025-07-27.
//

#if canImport(WidgetKit) && canImport(ActivityKit)
import ActivityKit
import WidgetKit
import SwiftUI

/// Live Activity widget displaying task progress and an animated gear
struct BackgroundTaskWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BackgroundTaskAttributes.self) { context in
            BackgroundTaskLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded region of the Dynamic Island
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        Image(systemName: "gearshape.fill")
                            .rotationEffect(.degrees(context.state.progress * 360))
                            .animation(.linear(duration: 0.2), value: context.state.progress)
                        Text("\(Int(context.state.progress * 100))%")
                            .monospacedDigit()
                            .animation(nil, value: context.state.progress)
                    }
                }
            } compactLeading: {
                Image(systemName: "gearshape.fill")
                    .rotationEffect(.degrees(context.state.progress * 360))
                    .animation(.linear(duration: 0.2), value: context.state.progress)
            } compactTrailing: {
                Text("\(Int(context.state.progress * 100))%")
                    .font(.footnote)
                    .monospacedDigit()
                    .animation(nil, value: context.state.progress)
            } minimal: {
                Image(systemName: "gearshape.fill")
                    .rotationEffect(.degrees(context.state.progress * 360))
                    .animation(.linear(duration: 0.2), value: context.state.progress)
            }
        }
    }
}

/// Lock screen/notification UI for the live activity.
/// Exposes a `progress` value for both runtime and preview usage.
struct BackgroundTaskLiveActivityView: View {
    let progress: Double

    /// Runtime initializer using the actual ActivityViewContext.
    init(context: ActivityViewContext<BackgroundTaskAttributes>) {
        self.progress = context.state.progress
    }

    /// Convenience initializer for previews with mock progress.
    init(progress: Double) {
        self.progress = progress
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "gearshape.fill")
                .rotationEffect(.degrees(progress * 360))
                .animation(.linear(duration: 0.2), value: progress)
            Text("\(Int(progress * 100))%")
                .bold()
                .monospacedDigit()
        }
        .padding(.horizontal)
    }
}

/// Preview provider for the live activity widget content.
/// Uses a mock progress value instead of ActivityViewContext.
struct BackgroundTaskWidget_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundTaskLiveActivityView(progress: 0.5)
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
#endif
