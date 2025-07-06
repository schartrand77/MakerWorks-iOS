//
//  TokenStorage.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation

/// Responsible for storing and retrieving authentication tokens and user info
final class TokenStorage {
    static let shared = TokenStorage()

    private let defaults = UserDefaults.standard

    private let tokenKey = "accessToken"
    private let emailKey = "userEmail"
    private let usernameKey = "username"
    private let groupsKey = "userGroups"

    private init() {}

    // MARK: - Save

    func saveToken(_ token: String) {
        defaults.set(token, forKey: tokenKey)
    }

    func saveEmail(_ email: String) {
        defaults.set(email, forKey: emailKey)
    }

    func saveUsername(_ username: String) {
        defaults.set(username, forKey: usernameKey)
    }

    func saveGroups(_ groups: String) {
        defaults.set(groups, forKey: groupsKey)
    }

    func saveAll(token: String, email: String, username: String, groups: String?) {
        saveToken(token)
        saveEmail(email)
        saveUsername(username)
        if let groups = groups {
            saveGroups(groups)
        }
    }

    // MARK: - Get

    func getToken() -> String? {
        defaults.string(forKey: tokenKey)
    }

    func getEmail() -> String? {
        defaults.string(forKey: emailKey)
    }

    func getUsername() -> String? {
        defaults.string(forKey: usernameKey)
    }

    func getGroups() -> String? {
        defaults.string(forKey: groupsKey)
    }

    // MARK: - Clear

    func clear() {
        defaults.removeObject(forKey: tokenKey)
        defaults.removeObject(forKey: emailKey)
        defaults.removeObject(forKey: usernameKey)
        defaults.removeObject(forKey: groupsKey)
    }
}
