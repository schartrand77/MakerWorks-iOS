//
//  BackgroundTaskWidgetBundle.swift
//  MakerWorksWidgetExtension
//
//  Created by Stephen Chartrand on 2025-07-27.
//

#if canImport(WidgetKit) && !os(iOS)
import SwiftUI
import WidgetKit

/// The WidgetBundle entry point for the MakerWorks widget extension.
/// This file must ONLY be included in the Widget Extension target, never the main app.
/// Wrapping with `#if canImport(WidgetKit)` ensures the compiler ignores it in the app target.
@main
struct MakerWorksWidgetBundle: WidgetBundle {
    var body: some Widget {
        BackgroundTaskWidget()
        // ProcessingLiveActivityWidget() temporarily removed or will be added when implemented
    }
}
#endif
