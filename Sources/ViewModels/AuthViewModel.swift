//
//  AuthViewModel.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Combine
import os

final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    private let logger = Logger(subsystem: "techpunk.MakerWorks", category: "AuthViewModel")

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    /// Checks if user is currently authenticated and fetches user profile.
    func checkAuth() {
        logger.info("Checking authentication…")
        isLoading = true
        errorMessage = nil

        authService.fetchCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.isAuthenticated = false
                    self.user = nil
                    self.errorMessage = "Failed to fetch user: \(error.localizedDescription)"
                    self.logger.error("Authentication failed: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.user = user
                self.isAuthenticated = true

                if let uuid = UUID(uuidString: user.id) {
                    self.logger.info("User authenticated: \(uuid.uuidString)")
                } else {
                    self.logger.info("User authenticated: \(user.id)")
                }
            })
            .store(in: &cancellables)
    }

    /// Logs out the current user.
    func logout() {
        logger.info("Logging out user.")
        authService.logout()
        isAuthenticated = false
        user = nil
        errorMessage = nil
        isLoading = false
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
