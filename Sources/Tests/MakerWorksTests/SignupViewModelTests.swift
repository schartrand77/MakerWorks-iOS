import XCTest
import Combine
@testable import MakerWorks

final class SignupViewModelTests: XCTestCase {
    var viewModel: SignupViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = SignupViewModel(authService: MockAuthService())
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testSignupSuccessPostsNotification() {
        let expectation = expectation(forNotification: .didLogin, object: nil, handler: nil)
        viewModel.email = "user@example.com"
        viewModel.password = "secret"
        viewModel.signup()
        wait(for: [expectation], timeout: 1.0)
    }
}

private class MockAuthService: AuthServiceProtocol {
    func fetchCurrentUser() -> AnyPublisher<User, Error> { fatalError() }
    func exchangeCodeForToken(code: String) -> AnyPublisher<User, Error> { fatalError() }
    func signup(email: String, password: String) -> AnyPublisher<User, Error> {
        let user = User(id: "1", email: email, username: "test", role: "user", isVerified: true)
        return Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    func signin(email: String, password: String) -> AnyPublisher<User, Error> { fatalError() }
    func debugMe() -> AnyPublisher<User, Error> { fatalError() }
    func adminUnlock(email: String) -> AnyPublisher<Void, Error> { fatalError() }
    func signout() {}
}
