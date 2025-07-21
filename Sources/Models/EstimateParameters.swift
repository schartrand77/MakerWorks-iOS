//
//  EstimateParameters.swift
//  MakerWorks
//
//  Created on 2025-07-06.
//

import Foundation

/// Request body for the estimate endpoint
struct EstimateParameters: Codable {
    let modelId: Int
    let xMM: Double
    let yMM: Double
    let zMM: Double
    let filamentType: String
    let filamentColors: [String]
    let printProfile: String
    let customText: String?

    enum CodingKeys: String, CodingKey {
        case modelId = "model_id"
        case xMM = "x_mm"
        case yMM = "y_mm"
        case zMM = "z_mm"
        case filamentType = "filament_type"
        case filamentColors = "filament_colors"
        case printProfile = "print_profile"
        case customText = "custom_text"
    }
}

extension EstimateParameters {
    /// Basic validation helper
    var isValid: Bool {
        return modelId > 0 &&
               xMM > 0 && yMM > 0 && zMM > 0 &&
               !filamentType.isEmpty &&
               !filamentColors.isEmpty &&
               !printProfile.isEmpty
    }
}
