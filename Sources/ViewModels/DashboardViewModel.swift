//
//  DashboardViewModel.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    /// Fetches the current user information from the API
    func fetchCurrentUser() {
        authService.fetchCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { user in
                self.user = user
            })
            .store(in: &cancellables)
    }

    /// Logs out the user by clearing tokens and user info
    func logout() {
        TokenStorage.shared.clear()
        self.user = nil
        NotificationCenter.default.post(name: .didLogout, object: nil)
    }
}

extension Notification.Name {
    static let didLogout = Notification.Name("didLogout")
}
