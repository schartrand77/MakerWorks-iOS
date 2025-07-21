//
//  NetworkClient.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Combine

/// Protocol defining the networking interface
protocol NetworkClient {
    /// Makes a request to the given API endpoint and decodes the response
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error>

    /// Makes a request where no response body is expected (just status check)
    func requestVoid(_ endpoint: APIEndpoint) -> AnyPublisher<Void, Error>
}

/// Default implementation of the NetworkClient
final class DefaultNetworkClient: NetworkClient {
    static let shared = DefaultNetworkClient(
        baseURL: URL(string: "http://127.0.0.1:8000")!,
        authenticator: Authenticator.shared
    )

    /// Base API endpoint used when constructing requests
    ///
    /// This is exposed so that other modules can build URLs or requests
    /// without needing to duplicate the base URL string.
    private(set) var baseURL: URL
    private let session: URLSession
    private let authenticator: Authenticator

    init(baseURL: URL, session: URLSession = .shared, authenticator: Authenticator) {
        self.baseURL = baseURL
        self.session = session
        self.authenticator = authenticator
    }

    /// Updates the base URL for subsequent requests
    func updateBaseURL(_ url: URL) {
        self.baseURL = url
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error> {
        var request = endpoint.urlRequest(baseURL: baseURL)
        authenticator.attachHeaders(to: &request)

        return session.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                if !(200...299).contains(response.statusCode) {
                    throw NetworkError.httpError(statusCode: response.statusCode)
                }

                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func requestVoid(_ endpoint: APIEndpoint) -> AnyPublisher<Void, Error> {
        var request = endpoint.urlRequest(baseURL: baseURL)
        authenticator.attachHeaders(to: &request)

        return session.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                if !(200...299).contains(response.statusCode) {
                    throw NetworkError.httpError(statusCode: response.statusCode)
                }

                return () // Void
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

/// Errors specific to networking
enum NetworkError: LocalizedError {
    case httpError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .httpError(let code):
            return "HTTP Error: \(code)"
        }
    }
}
