//
//  LifeLedgerWidgetLiveActivity.swift
//  LifeLedgerWidget
//
//  Created by Gowtham on 08/02/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LifeLedgerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LifeLedgerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LifeLedgerWidgetAttributes.self) { context in
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

extension LifeLedgerWidgetAttributes {
    fileprivate static var preview: LifeLedgerWidgetAttributes {
        LifeLedgerWidgetAttributes(name: "World")
    }
}

extension LifeLedgerWidgetAttributes.ContentState {
    fileprivate static var smiley: LifeLedgerWidgetAttributes.ContentState {
        LifeLedgerWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LifeLedgerWidgetAttributes.ContentState {
         LifeLedgerWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LifeLedgerWidgetAttributes.preview) {
   LifeLedgerWidgetLiveActivity()
} contentStates: {
    LifeLedgerWidgetAttributes.ContentState.smiley
    LifeLedgerWidgetAttributes.ContentState.starEyes
}
