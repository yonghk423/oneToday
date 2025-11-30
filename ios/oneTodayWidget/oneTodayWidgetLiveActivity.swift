//
//  oneTodayWidgetLiveActivity.swift
//  oneTodayWidget
//
//  Created by yonghee on 11/29/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct oneTodayWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct oneTodayWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: oneTodayWidgetAttributes.self) { context in
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

extension oneTodayWidgetAttributes {
    fileprivate static var preview: oneTodayWidgetAttributes {
        oneTodayWidgetAttributes(name: "World")
    }
}

extension oneTodayWidgetAttributes.ContentState {
    fileprivate static var smiley: oneTodayWidgetAttributes.ContentState {
        oneTodayWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: oneTodayWidgetAttributes.ContentState {
         oneTodayWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: oneTodayWidgetAttributes.preview) {
   oneTodayWidgetLiveActivity()
} contentStates: {
    oneTodayWidgetAttributes.ContentState.smiley
    oneTodayWidgetAttributes.ContentState.starEyes
}
