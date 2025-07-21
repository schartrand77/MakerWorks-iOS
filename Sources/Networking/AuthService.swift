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
    func signup(email: String, password: String) -> AnyPublisher<User, Error>
    func signin(email: String, password: String) -> AnyPublisher<User, Error>
    func debugMe() -> AnyPublisher<User, Error>
    func adminUnlock(email: String) -> AnyPublisher<Void, Error>
    func signout()
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

    func signup(email: String, password: String) -> AnyPublisher<User, Error> {
        client.request(.signup(email: email, password: password))
    }

    func signin(email: String, password: String) -> AnyPublisher<User, Error> {
        client.request(.signin(email: email, password: password))
    }

    func debugMe() -> AnyPublisher<User, Error> {
        client.request(.debugMe)
    }

    func adminUnlock(email: String) -> AnyPublisher<Void, Error> {
        client.request(.adminUnlock(email: email))
    }

    /// Signs out the user and clears token storage
    func signout() {
        TokenStorage.shared.clear()
    }
}
