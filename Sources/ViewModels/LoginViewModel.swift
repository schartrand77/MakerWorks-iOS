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
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    private let logger = Logger(subsystem: "techpunk.MakerWorks", category: "LoginViewModel")

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    /// Starts the login process with username & password
    func login() {
        logger.info("Attempting login")
        self.isLoading = true
        self.errorMessage = nil
        authService.login(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.logger.error("Login failed: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.isLoading = false
                if let uuid = UUID(uuidString: user.id) {
                    self.logger.info("Login successful: \(uuid.uuidString)")
                } else {
                    self.logger.info("Login successful: \(user.id)")
                }
                NotificationCenter.default.post(name: .didLogin, object: nil)
            })
            .store(in: &cancellables)
    }
}

extension Notification.Name {
    static let didLogin = Notification.Name("didLogin")
}
