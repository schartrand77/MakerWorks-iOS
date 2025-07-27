//
//  MakerWorksWidgetExtensionLiveActivity.swift
//  MakerWorksWidgetExtension
//
//  Created by Stephen Chartrand on 2025-07-27.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MakerWorksWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MakerWorksWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MakerWorksWidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MakerWorksWidgetExtensionAttributes {
    fileprivate static var preview: MakerWorksWidgetExtensionAttributes {
        MakerWorksWidgetExtensionAttributes(name: "World")
    }
}

extension MakerWorksWidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: MakerWorksWidgetExtensionAttributes.ContentState {
        MakerWorksWidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MakerWorksWidgetExtensionAttributes.ContentState {
         MakerWorksWidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MakerWorksWidgetExtensionAttributes.preview) {
   MakerWorksWidgetExtensionLiveActivity()
} contentStates: {
    MakerWorksWidgetExtensionAttributes.ContentState.smiley
    MakerWorksWidgetExtensionAttributes.ContentState.starEyes
}
