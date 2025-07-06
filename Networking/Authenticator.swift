//
//  Authenticator.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation

/// Responsible for attaching authentication headers to requests
final class Authenticator {
    static let shared = Authenticator()

    private var accessToken: String? {
        TokenStorage.shared.getToken()
    }

    private var userEmail: String? {
        TokenStorage.shared.getEmail()
    }

    private var username: String? {
        TokenStorage.shared.getUsername()
    }

    private var userGroups: String? {
        TokenStorage.shared.getGroups()
    }

    private init() {}

    /// Attaches the Authorization header and any required X-Authentik headers
    func attachHeaders(to request: inout URLRequest) {
        if let token = accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let email = userEmail {
            request.addValue(email, forHTTPHeaderField: "X-Authentik-Email")
        }

        if let uname = username {
            request.addValue(uname, forHTTPHeaderField: "X-Authentik-Username")
        }

        if let groups = userGroups {
            request.addValue(groups, forHTTPHeaderField: "X-Authentik-Groups")
        }
    }
}
