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
    private var cancellables = Set<AnyCancellable>()

    init(client: NetworkClient = DefaultNetworkClient.shared) {
        self.client = client
    }

    func fetchCurrentUser() -> AnyPublisher<User, Error> {
        client.request(APIEndpoint.currentUser)
    }

    func exchangeCodeForToken(code: String) -> AnyPublisher<User, Error> {
        client.request(APIEndpoint.exchangeCode(code))
    }

    func signup(email: String, password: String) -> AnyPublisher<User, Error> {
        client.request(APIEndpoint.signup(email: email, password: password))
    }

    func signin(email: String, password: String) -> AnyPublisher<User, Error> {
        client.request(APIEndpoint.signin(email: email, password: password))
    }

    func debugMe() -> AnyPublisher<User, Error> {
        client.request(APIEndpoint.debugMe)
    }

    func adminUnlock(email: String) -> AnyPublisher<Void, Error> {
        client.requestVoid(APIEndpoint.adminUnlock(email: email))
    }

    func signout() {
        client.requestVoid(APIEndpoint.signout)
            .sink(receiveCompletion: { [weak self] _ in
                TokenStorage.shared.clear()
                self?.cancellables.removeAll()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
