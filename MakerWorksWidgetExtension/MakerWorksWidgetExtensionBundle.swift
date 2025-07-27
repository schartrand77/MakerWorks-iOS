//
//  MakerWorksWidgetExtensionBundle.swift
//  MakerWorksWidgetExtension
//
//  Created by Stephen Chartrand on 2025-07-27.
//

import WidgetKit
import SwiftUI

@main
struct MakerWorksWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        MakerWorksWidgetExtension()
        MakerWorksWidgetExtensionControl()
        MakerWorksWidgetExtensionLiveActivity()
    }
}
