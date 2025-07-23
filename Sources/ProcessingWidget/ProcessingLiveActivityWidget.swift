import ActivityKit
import WidgetKit
import SwiftUI

/// A simple view that rotates a gear symbol periodically.
private struct RotatingGear: View {
    var progress: Double

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let additional = context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1)
            Image(systemName: "gearshape.fill")
                .rotationEffect(.degrees(progress * 360 + additional * 360))
        }
    }
}

/// Widget showing processing progress in the Dynamic Island.
struct ProcessingLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ProcessingAttributes.self) { context in
            HStack(spacing: 8) {
                RotatingGear(progress: context.state.progress)
                Text("\(Int(context.state.progress * 100))%")
                    .bold()
                    .monospacedDigit()
            }
            .padding(.horizontal)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 4) {
                        RotatingGear(progress: context.state.progress)
                        Text("\(Int(context.state.progress * 100))%")
                            .monospacedDigit()
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.attributes.taskName)
                        .font(.footnote)
                }
            } compactLeading: {
                RotatingGear(progress: context.state.progress)
            } compactTrailing: {
                Text("\(Int(context.state.progress * 100))%")
                    .font(.footnote)
                    .monospacedDigit()
            } minimal: {
                RotatingGear(progress: context.state.progress)
            }
        }
    }
}

struct ProcessingLiveActivityWidget_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingLiveActivityWidget()
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
