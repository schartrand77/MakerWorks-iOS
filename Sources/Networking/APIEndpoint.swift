//
//  APIEndpoint.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation

enum APIEndpoint {
    case signup(email: String, password: String)
    case signin(email: String, password: String)
    case login(username: String, password: String)
    case currentUser
    case debugMe
    case adminUnlock(email: String)
    case uploadModel
    case listModels
    case estimate
    case exchangeCode(String)
    case logout
    // … add more cases as you implement other endpoints

    func urlRequest(baseURL: URL) -> URLRequest {
        var url: URL
        var request: URLRequest

        switch self {
        case let .signup(email, password):
            url = baseURL.appendingPathComponent("/api/v1/auth/signup")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["email": email, "password": password]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        case let .signin(email, password):
            url = baseURL.appendingPathComponent("/api/v1/auth/signin")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["email": email, "password": password]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        case let .login(username, password):
            url = baseURL.appendingPathComponent("/api/v1/auth/login")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["username": username, "password": password]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        case .currentUser:
            url = baseURL.appendingPathComponent("/api/v1/auth/me")
            request = URLRequest(url: url)
            request.httpMethod = "GET"

        case .debugMe:
            url = baseURL.appendingPathComponent("/api/v1/auth/debug")
            request = URLRequest(url: url)
            request.httpMethod = "GET"

        case let .adminUnlock(email):
            url = baseURL.appendingPathComponent("/api/v1/auth/admin/unlock")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["email": email]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        case .uploadModel:
            url = baseURL.appendingPathComponent("/api/v1/upload/")
            request = URLRequest(url: url)
            request.httpMethod = "POST"

        case .listModels:
            url = baseURL.appendingPathComponent("/api/v1/models")
            request = URLRequest(url: url)
            request.httpMethod = "GET"

        case .estimate:
            url = baseURL.appendingPathComponent("/api/v1/estimate/estimates/")
            request = URLRequest(url: url)
            request.httpMethod = "POST"

        case .exchangeCode(let code):
            url = baseURL.appendingPathComponent("/api/v1/auth/exchange/")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["code": code]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        case .logout:
            url = baseURL.appendingPathComponent("/api/v1/auth/logout")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
        }

        return request
    }
}
