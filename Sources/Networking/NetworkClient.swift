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
    /// Shared instance used across the app.
    ///
    /// Uses a safe pattern to avoid referencing `Self` in a stored property initializer.
    static let shared: DefaultNetworkClient = {
        let url = DefaultNetworkClient.resolveBaseURL()
        return DefaultNetworkClient(
            baseURL: url,
            authenticator: Authenticator.shared
        )
    }()

    /// Determines the base URL for the shared client. In DEBUG builds this will
    /// check for the `BACKEND_URL` environment variable and use it if valid.
    /// Otherwise the production API URL is returned.
    private static func resolveBaseURL() -> URL {
        #if DEBUG
        if let override = ProcessInfo.processInfo.environment["BACKEND_URL"],
           let url = URL(string: override) {
            return url
        }
        #endif
        return URL(string: "https://api.makerworks.app")!
    }

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

    // MARK: - Modern Concurrency

    /// Performs a network request using Swift's `async/await` syntax and decodes the response.
    /// - Parameter endpoint: The API endpoint to hit.
    /// - Returns: The decoded response value.
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        var request = endpoint.urlRequest(baseURL: baseURL)
        authenticator.attachHeaders(to: &request)

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.httpError(statusCode: http.statusCode)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// Performs a network request where no response body is expected using `async/await`.
    /// - Parameter endpoint: The API endpoint to hit.
    func requestVoid(_ endpoint: APIEndpoint) async throws {
        var request = endpoint.urlRequest(baseURL: baseURL)
        authenticator.attachHeaders(to: &request)

        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.httpError(statusCode: http.statusCode)
        }
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
