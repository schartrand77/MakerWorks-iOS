import SwiftUI
import WidgetKit

@main
struct MakerWorksWidgetBundle: WidgetBundle {
    var body: some Widget {
        BackgroundTaskWidget()
        ProcessingLiveActivityWidget()
    }
}
