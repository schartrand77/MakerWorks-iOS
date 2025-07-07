//
//  Model.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation

struct Model: Codable, Identifiable {
    let id: Int
    let name: String
    let uploader: String
    let uploadedAt: String
    let description: String?
    let previewImage: URL?
    let dimensions: Dimensions?
    let volumeCm3: Double?
    let tags: [String]?
    let faceCount: Int?
    let role: String?
    let category: String?
}

// Optional nested type for dimensions
struct Dimensions: Codable {
    let x: Double
    let y: Double
    let z: Double
}
