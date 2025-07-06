//
//  AuthViewModel.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var user: User?

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    func checkAuth() {
        authService.fetchCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.isAuthenticated = false
                    self.user = nil
                case .finished:
                    break
                }
            }, receiveValue: { user in
                self.user = user
                self.isAuthenticated = true
            })
            .store(in: &self.cancellables)
    }

    func logout() {
        authService.logout()
        self.isAuthenticated = false
        self.user = nil
    }
}
