//
//  LoginViewModel.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Combine
import os

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    private let logger = Logger(subsystem: "techpunk.MakerWorks", category: "LoginViewModel")

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    /// Starts the sign-in process with email & password
    func signin() {
        logger.info("Attempting sign in")
        self.isLoading = true
        self.errorMessage = nil
        authService.signin(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.logger.error("Sign in failed: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.isLoading = false
                if let uuid = UUID(uuidString: user.id) {
                    self.logger.info("Sign in successful: \(uuid.uuidString)")
                } else {
                    self.logger.info("Sign in successful: \(user.id)")
                }
                NotificationCenter.default.post(name: .didLogin, object: nil)
            })
            .store(in: &cancellables)
    }
}

extension Notification.Name {
    static let didLogin = Notification.Name("didLogin")
}
