import XCTest
@testable import MakerWorks

final class FavoritesManagerTests: XCTestCase {
    override func tearDown() {
        FavoritesManager.shared.favorites.removeAll()
        UserDefaults.standard.removeObject(forKey: "favoriteModelIDs")
        super.tearDown()
    }

    func testToggleFavorite() {
        FavoritesManager.shared.toggle(id: 1)
        XCTAssertTrue(FavoritesManager.shared.isFavorite(id: 1))
        FavoritesManager.shared.toggle(id: 1)
        XCTAssertFalse(FavoritesManager.shared.isFavorite(id: 1))
    }

    func testPersistence() {
        FavoritesManager.shared.toggle(id: 2)
        let newManager = FavoritesManager.shared
        XCTAssertTrue(newManager.isFavorite(id: 2))
    }
}
