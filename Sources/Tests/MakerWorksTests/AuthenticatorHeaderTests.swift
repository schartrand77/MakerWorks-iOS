import XCTest
@testable import MakerWorks

final class AuthenticatorHeaderTests: XCTestCase {
    override func tearDown() {
        TokenStorage.shared.clear()
        super.tearDown()
    }

    func testHeadersAttached() {
        TokenStorage.shared.saveAll(token: "t", email: "e", username: "u", groups: "g")
        var request = URLRequest(url: URL(string: "https://example.com")!)
        Authenticator.shared.attachHeaders(to: &request)

        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer t")
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Authentik-Email"), "e")
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Authentik-Username"), "u")
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Authentik-Groups"), "g")
    }
}
