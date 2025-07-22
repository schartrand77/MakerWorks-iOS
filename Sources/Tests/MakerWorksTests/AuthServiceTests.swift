import XCTest
import Combine
@testable import MakerWorks

final class AuthServiceTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        TokenStorage.shared.clear()
    }

    func testSignoutRequestsEndpointAndClearsStorage() {
        let client = MockNetworkClient()
        let service = AuthService(client: client)
        TokenStorage.shared.saveAll(token: "t", email: "e", username: "u", groups: "g")
        service.signout()
        XCTAssertTrue(client.didCallSignout)
        XCTAssertNil(TokenStorage.shared.getToken())
        XCTAssertNil(TokenStorage.shared.getEmail())
        XCTAssertNil(TokenStorage.shared.getUsername())
        XCTAssertNil(TokenStorage.shared.getGroups())
    }
}

private final class MockNetworkClient: NetworkClient {
    var didCallSignout = false

    func request<T>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error> where T : Decodable {
        fatalError("not implemented")
    }

    func requestVoid(_ endpoint: APIEndpoint) -> AnyPublisher<Void, Error> {
        if case .signout = endpoint {
            didCallSignout = true
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
