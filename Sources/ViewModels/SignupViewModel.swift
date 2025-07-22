import Foundation
import Combine
import os

final class SignupViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    private let logger = Logger(subsystem: "techpunk.MakerWorks", category: "SignupViewModel")

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    /// Starts the sign-up process with email & password
    func signup() {
        logger.info("Attempting sign up")
        self.isLoading = true
        self.errorMessage = nil
        authService.signup(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.logger.error("Sign up failed: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.isLoading = false
                if let uuid = UUID(uuidString: user.id) {
                    self.logger.info("Sign up successful: \(uuid.uuidString)")
                } else {
                    self.logger.info("Sign up successful: \(user.id)")
                }
                NotificationCenter.default.post(name: .didLogin, object: nil)
            })
            .store(in: &cancellables)
    }
}
