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
    func logout()
}

final class AuthService: AuthServiceProtocol {
    private let client: NetworkClient

    init(client: NetworkClient = DefaultNetworkClient.shared) {
        self.client = client
    }

    func fetchCurrentUser() -> AnyPublisher<User, Error> {
        client.request(.currentUser)
    }

    func logout() {
        TokenStorage.shared.clear()
    }
}
