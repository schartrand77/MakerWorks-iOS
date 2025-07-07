//
//  TokenStorage.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Security

/// Responsible for storing and retrieving authentication tokens and user info
final class TokenStorage {
    static let shared = TokenStorage()

    private let defaults = UserDefaults.standard

    private let service = "MakerWorksTokenStorage"

    private let tokenKey = "accessToken"
    private let emailKey = "userEmail"
    private let usernameKey = "username"
    private let groupsKey = "userGroups"

    private let migrationKey = "TokenStorageMigrated"

    private init() {
        migrateIfNeeded()
    }

    // MARK: - Migration

    private func migrateIfNeeded() {
        guard !defaults.bool(forKey: migrationKey) else { return }

        if let token = defaults.string(forKey: tokenKey) {
            saveToken(token)
            defaults.removeObject(forKey: tokenKey)
        }
        if let email = defaults.string(forKey: emailKey) {
            saveEmail(email)
            defaults.removeObject(forKey: emailKey)
        }
        if let username = defaults.string(forKey: usernameKey) {
            saveUsername(username)
            defaults.removeObject(forKey: usernameKey)
        }
        if let groups = defaults.string(forKey: groupsKey) {
            saveGroups(groups)
            defaults.removeObject(forKey: groupsKey)
        }

        defaults.set(true, forKey: migrationKey)
    }

    // MARK: - Save

    func saveToken(_ token: String) {
        saveKeychainValue(token, for: tokenKey)
    }

    func saveEmail(_ email: String) {
        saveKeychainValue(email, for: emailKey)
    }

    func saveUsername(_ username: String) {
        saveKeychainValue(username, for: usernameKey)
    }

    func saveGroups(_ groups: String) {
        saveKeychainValue(groups, for: groupsKey)
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
        getKeychainValue(for: tokenKey)
    }

    func getEmail() -> String? {
        getKeychainValue(for: emailKey)
    }

    func getUsername() -> String? {
        getKeychainValue(for: usernameKey)
    }

    func getGroups() -> String? {
        getKeychainValue(for: groupsKey)
    }

    // MARK: - Clear

    func clear() {
        deleteKeychainValue(for: tokenKey)
        deleteKeychainValue(for: emailKey)
        deleteKeychainValue(for: usernameKey)
        deleteKeychainValue(for: groupsKey)
    }

    // MARK: - Keychain Helpers

    private func keychainQuery(for key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: service
        ]
    }

    private func saveKeychainValue(_ value: String, for key: String) {
        var query = keychainQuery(for: key)
        let data = Data(value.utf8)

        if SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess {
            let attributes = [kSecValueData as String: data]
            SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        } else {
            query[kSecValueData as String] = data
            query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    private func getKeychainValue(for key: String) -> String? {
        var query = keychainQuery(for: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var dataRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataRef)
        guard status == errSecSuccess, let data = dataRef as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func deleteKeychainValue(for key: String) {
        let query = keychainQuery(for: key)
        SecItemDelete(query as CFDictionary)
    }
}
