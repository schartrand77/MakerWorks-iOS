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
    case currentUser
    case debugMe
    case adminUnlock(email: String)
    case uploadModel(data: Data, boundary: String)
    case listModels
    case estimate(parameters: EstimateParameters)
    case exchangeCode(String)
    case signout
    case filamentPicker
    // … add more cases as you implement other endpoints

    func urlRequest(baseURL: URL) -> URLRequest {
        var url: URL
        var request: URLRequest

        switch self {
        case let .signup(email, password):
            url = baseURL.appendingPathComponent("/api/v1/auth/signup/")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["email": email, "password": password]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                fatalError("Failed to encode signup body: \(error)")
            }

        case let .signin(email, password):
            url = baseURL.appendingPathComponent("/api/v1/auth/signin/")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["email": email, "password": password]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                fatalError("Failed to encode signin body: \(error)")
            }

        case .currentUser:
            url = baseURL.appendingPathComponent("/api/v1/auth/me/")
            request = URLRequest(url: url)
            request.httpMethod = "GET"

        case .debugMe:
            url = baseURL.appendingPathComponent("/api/v1/auth/debug/")
            request = URLRequest(url: url)
            request.httpMethod = "GET"

        case let .adminUnlock(email):
            url = baseURL.appendingPathComponent("/api/v1/admin/unlock/")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["email": email]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                fatalError("Failed to encode adminUnlock body: \(error)")
            }

        case let .uploadModel(data, boundary):
            url = baseURL.appendingPathComponent("/api/v1/upload/")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = data

        case .listModels:
            url = baseURL.appendingPathComponent("/api/v1/models/")
            request = URLRequest(url: url)
            request.httpMethod = "GET"

        case let .estimate(parameters):
            url = baseURL.appendingPathComponent("/api/v1/estimate/estimates/")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(parameters)
            } catch {
                fatalError("Failed to encode estimate parameters: \(error)")
            }

        case .exchangeCode(let code):
            url = baseURL.appendingPathComponent("/api/v1/auth/exchange/")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["code": code]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                fatalError("Failed to encode exchangeCode body: \(error)")
            }

        case .signout:
            url = baseURL.appendingPathComponent("/api/v1/auth/signout/")
            request = URLRequest(url: url)
            request.httpMethod = "POST"

        case .filamentPicker:
            url = baseURL.appendingPathComponent("/api/v1/filaments/picker/")
            request = URLRequest(url: url)
            request.httpMethod = "GET"
        }

        return request
    }
}
