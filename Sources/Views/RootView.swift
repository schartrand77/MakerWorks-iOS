import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "cube.box")
                }

            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "person.crop.circle")
                }

            EstimateView()
                .tabItem {
                    Label("Estimate", systemImage: "ruler.fill")
                }
        }
    }
}
