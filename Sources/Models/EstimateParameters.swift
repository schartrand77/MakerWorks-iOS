//
//  EstimateParameters.swift
//  MakerWorks
//
//  Created by OpenAI Codex on 2025-07-06.
//

import Foundation

/// Request body for the estimate endpoint
struct EstimateParameters: Codable {
    let model_id: Int
    let x_mm: Double
    let y_mm: Double
    let z_mm: Double
    let filament_type: String
    let filament_colors: [String]
    let print_profile: String
    let custom_text: String?
}
