import Foundation

/// Stores favorite model IDs using UserDefaults
final class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published private(set) var favorites: Set<Int>
    private let defaults = UserDefaults.standard
    private let key = "favoriteModelIDs"

    private init() {
        let saved = defaults.array(forKey: key) as? [Int] ?? []
        favorites = Set(saved)
    }

    func toggle(id: Int) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        defaults.set(Array(favorites), forKey: key)
    }

    func isFavorite(id: Int) -> Bool {
        favorites.contains(id)
    }
}
