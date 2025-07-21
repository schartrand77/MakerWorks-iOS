import SwiftUI

struct RootView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "cube.box")
                }
                .tag(0)

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
                .tag(1)

            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "person.crop.circle")
                }
                .tag(2)

            EstimateView()
                .tabItem {
                    Label("Estimate", systemImage: "ruler.fill")
                }
                .tag(3)
        }
        .onReceive(NotificationCenter.default.publisher(for: .showFavorites)) { _ in
            selection = 1
        }
    }
}
