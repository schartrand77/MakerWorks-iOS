import SwiftUI

struct FavoriteButton: View {
    let modelID: Int
    @ObservedObject var manager: FavoritesManager = .shared

    var body: some View {
        Button(action: {
            manager.toggle(id: modelID)
        }) {
            Image(systemName: manager.isFavorite(id: modelID) ? "star.fill" : "star")
                .foregroundColor(.yellow)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FavoriteButton(modelID: 1)
}
