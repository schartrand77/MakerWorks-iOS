//
//  LoginViewModel.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Combine
import AuthenticationServices
import os

final class LoginViewModel: NSObject, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    private let logger = Logger(subsystem: "techpunk.MakerWorks", category: "LoginViewModel")

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    /// Starts the login process via OIDC
    func login() {
        logger.info("Starting OIDC login…")
        self.isLoading = true
        self.errorMessage = nil

        startOIDCLogin()
    }

    /// Initiates the OIDC login using ASWebAuthenticationSession
    private func startOIDCLogin() {
        guard let authURL = URL(string: "https://your-authentik-server/if/flow/your-flow/") else {
            self.isLoading = false
            self.errorMessage = "Invalid Auth URL"
            return
        }

        let callbackScheme = "makerworks"  // e.g., makerworks://auth/callback
        let session = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: callbackScheme
        ) { [weak self] callbackURL, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.logger.error("OIDC login failed: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                    return
                }

                guard let callbackURL = callbackURL else {
                    self?.errorMessage = "No callback URL received"
                    return
                }

                self?.handleCallbackURL(callbackURL)
            }
        }

        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }

    /// Handles the OIDC callback URL
    private func handleCallbackURL(_ url: URL) {
        logger.info("Handling OIDC callback URL: \(url.absoluteString)")

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let code = queryItems.first(where: { $0.name == "code" })?.value
        else {
            self.errorMessage = "Invalid callback parameters"
            return
        }

        logger.info("Authorization code received: \(code)")

        // Exchange code for token
        authService.exchangeCodeForToken(code: code)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.logger.error("Token exchange failed: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] user in
                self?.isLoading = false
                if let uuid = UUID(uuidString: user.id) {
                    self?.logger.info("Login successful: \(uuid.uuidString)")
                } else {
                    self?.logger.info("Login successful: \(user.id)")
                }
                NotificationCenter.default.post(name: .didLogin, object: nil)
            })
            .store(in: &cancellables)
    }
}

extension LoginViewModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
           let window = scene.windows.first(where: { $0.isKeyWindow }) {
            return window
        } else {
            return ASPresentationAnchor()
        }
    }
}

extension Notification.Name {
    static let didLogin = Notification.Name("didLogin")
}
