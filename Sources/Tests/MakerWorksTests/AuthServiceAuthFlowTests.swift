import XCTest
import Combine
@testable import MakerWorks

final class AuthServiceAuthFlowTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    override func tearDown() {
        TokenStorage.shared.clear()
        cancellables.removeAll()
        super.tearDown()
    }

    func testSigninStoresTokenAndUserInfo() {
        let client = MockAuthClient()
        let service = AuthService(client: client)

        let exp = expectation(description: "signin")
        var result: User?
        service.signin(email: "e", password: "p")
            .sink(receiveCompletion: { _ in }, receiveValue: { user in
                result = user
                exp.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(result?.id, client.user.id)
        XCTAssertEqual(TokenStorage.shared.getToken(), "token")
        XCTAssertEqual(TokenStorage.shared.getEmail(), client.user.email)
        XCTAssertEqual(TokenStorage.shared.getUsername(), client.user.username)
        XCTAssertEqual(TokenStorage.shared.getGroups(), "staff")
    }

    func testSignupStoresTokenAndUserInfo() {
        let client = MockAuthClient()
        let service = AuthService(client: client)

        let exp = expectation(description: "signup")
        service.signup(email: "e", password: "p")
            .sink(receiveCompletion: { _ in exp.fulfill() }, receiveValue: { _ in })
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(TokenStorage.shared.getToken(), "token")
        XCTAssertEqual(TokenStorage.shared.getEmail(), client.user.email)
        XCTAssertEqual(TokenStorage.shared.getUsername(), client.user.username)
        XCTAssertEqual(TokenStorage.shared.getGroups(), "staff")
    }

    func testExchangeStoresTokenAndUserInfo() {
        let client = MockAuthClient()
        let service = AuthService(client: client)

        let exp = expectation(description: "exchange")
        service.exchangeCodeForToken(code: "abc")
            .sink(receiveCompletion: { _ in exp.fulfill() }, receiveValue: { _ in })
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(TokenStorage.shared.getToken(), "token")
        XCTAssertEqual(TokenStorage.shared.getEmail(), client.user.email)
        XCTAssertEqual(TokenStorage.shared.getUsername(), client.user.username)
        XCTAssertEqual(TokenStorage.shared.getGroups(), "staff")
    }

    func testAuthenticatorUsesStoredValuesAfterSignin() {
        let client = MockAuthClient()
        let service = AuthService(client: client)
        let exp = expectation(description: "signin")
        service.signin(email: "e", password: "p")
            .sink(receiveCompletion: { _ in exp.fulfill() }, receiveValue: { _ in })
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1.0)

        var request = URLRequest(url: URL(string: "https://example.com")!)
        Authenticator.shared.attachHeaders(to: &request)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer token")
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Authentik-Email"), client.user.email)
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Authentik-Username"), client.user.username)
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Authentik-Groups"), "staff")
    }
}

private final class MockAuthClient: NetworkClient {
    let user = User(id: "1", email: "a@b.com", username: "user", role: "member", isVerified: true)

    func request<T>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error> where T : Decodable {
        let response = AuthResponse(accessToken: "token", email: user.email, username: user.username, groups: "staff", user: user)
        return Just(response as! T)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func requestVoid(_ endpoint: APIEndpoint) -> AnyPublisher<Void, Error> {
        fatalError("not implemented")
    }
}
