import XCTest
@testable import MakerWorks

final class TokenStorageTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        TokenStorage.shared.clear()
    }

    func testSaveAndRetrieve() {
        TokenStorage.shared.saveAll(token: "t", email: "e", username: "u", groups: "g")
        XCTAssertEqual(TokenStorage.shared.getToken(), "t")
        XCTAssertEqual(TokenStorage.shared.getEmail(), "e")
        XCTAssertEqual(TokenStorage.shared.getUsername(), "u")
        XCTAssertEqual(TokenStorage.shared.getGroups(), "g")
    }

    func testMigrationFromUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set("oldT", forKey: "accessToken")
        defaults.set("oldE", forKey: "userEmail")
        defaults.set("oldU", forKey: "username")
        defaults.set("oldG", forKey: "userGroups")
        defaults.set(false, forKey: "TokenStorageMigrated")
        let storage = TokenStorage.shared
        XCTAssertEqual(storage.getToken(), "oldT")
        XCTAssertNil(defaults.string(forKey: "accessToken"))
    }
}
