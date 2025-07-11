import XCTest
@testable import MakerWorks

final class NetworkClientTests: XCTestCase {
    func testUpdateBaseURL() {
        let initialURL = URL(string: "https://example.com")!
        let client = DefaultNetworkClient(baseURL: initialURL, authenticator: Authenticator.shared)
        let newURL = URL(string: "https://new.example.com")!
        client.updateBaseURL(newURL)
        XCTAssertEqual(client.baseURL, newURL)
    }
}
