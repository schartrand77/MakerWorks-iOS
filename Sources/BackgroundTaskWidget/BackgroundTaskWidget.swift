import ActivityKit
import WidgetKit
import SwiftUI

// Live Activity widget displaying task progress and an animated gear
struct BackgroundTaskWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BackgroundTaskAttributes.self) { context in
            BackgroundTaskLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        Image(systemName: "gearshape.fill")
                            .rotationEffect(.degrees(context.state.progress * 360))
                        Text("\(Int(context.state.progress * 100))%")
                            .monospacedDigit()
                    }
                }
            } compactLeading: {
                Image(systemName: "gearshape.fill")
                    .rotationEffect(.degrees(context.state.progress * 360))
            } compactTrailing: {
                Text("\(Int(context.state.progress * 100))%")
                    .font(.footnote)
                    .monospacedDigit()
            } minimal: {
                Image(systemName: "gearshape.fill")
                    .rotationEffect(.degrees(context.state.progress * 360))
            }
        }
    }
}

// Lock screen/notification UI
struct BackgroundTaskLiveActivityView: View {
    let context: ActivityViewContext<BackgroundTaskAttributes>

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "gearshape.fill")
                .rotationEffect(.degrees(context.state.progress * 360))
            Text("\(Int(context.state.progress * 100))%")
                .bold()
                .monospacedDigit()
        }
        .padding(.horizontal)
    }
}

struct BackgroundTaskWidget_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundTaskWidget()
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
