//
//  APIEndpoint.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation

enum APIEndpoint {
    case currentUser
    case uploadModel
    case listModels
    case estimate
    case exchangeCode(String)
    case login
    case logout
    // … add more cases as you implement other endpoints

    func urlRequest(baseURL: URL) -> URLRequest {
        var url: URL
        var request: URLRequest

        switch self {
        case .currentUser:
            url = baseURL.appendingPathComponent("/api/v1/auth/me")
            request = URLRequest(url: url)
            request.httpMethod = "GET"

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

        case .login:
            url = baseURL.appendingPathComponent("/api/v1/auth/login")
            request = URLRequest(url: url)
            request.httpMethod = "POST"

        case .logout:
            url = baseURL.appendingPathComponent("/api/v1/auth/logout")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
        }

        return request
    }
}
