//
//  User.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation

struct User: Codable {
    let id: String
    let email: String
    let username: String
    let role: String
    let isVerified: Bool
}
