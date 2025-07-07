//
//  AuthService.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Combine

protocol AuthServiceProtocol {
    func fetchCurrentUser() -> AnyPublisher<User, Error>
    func exchangeCodeForToken(code: String) -> AnyPublisher<User, Error>
    func logout()
}

final class AuthService: AuthServiceProtocol {
    private let client: NetworkClient

    init(client: NetworkClient = DefaultNetworkClient.shared) {
        self.client = client
    }

    /// Fetch the currently logged-in user
    func fetchCurrentUser() -> AnyPublisher<User, Error> {
        client.request(.currentUser)
    }

    /// Exchange OIDC authorization code for tokens & fetch user
    func exchangeCodeForToken(code: String) -> AnyPublisher<User, Error> {
        client.request(.exchangeCode(code))
    }

    /// Logs out the user and clears token storage
    func logout() {
        TokenStorage.shared.clear()
    }
}
