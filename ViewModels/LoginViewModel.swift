//
//  LoginViewModel.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    /// Starts the login process (stubbed for now — replace with OIDC logic)
    func login() {
        self.isLoading = true
        self.errorMessage = nil

        // 🪪 Replace this with your OIDC authentication flow
        simulateOIDCLogin()
    }

    private func simulateOIDCLogin() {
        // Simulate successful login after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let dummyToken = "dummy-access-token"
            let dummyEmail = "user@example.com"
            let dummyUsername = "maker_user"
            let dummyGroups = "MakerWorks-User"

            TokenStorage.shared.saveAll(
                token: dummyToken,
                email: dummyEmail,
                username: dummyUsername,
                groups: dummyGroups
            )

            self.fetchCurrentUser()
        }
    }

    private func fetchCurrentUser() {
        authService.fetchCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false

                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { user in
                // Successfully authenticated
                NotificationCenter.default.post(name: .didLogin, object: nil)
            })
            .store(in: &cancellables)
    }
}

extension Notification.Name {
    static let didLogin = Notification.Name("didLogin")
}
