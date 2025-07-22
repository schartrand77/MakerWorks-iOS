//
//  FilamentPickerData.swift
//  MakerWorks
//
//  Created by Codex on 2025-07-21.
//

import Foundation

/// Response model for the `/filaments/picker` endpoint
struct FilamentPickerData: Codable {
    let filamentTypes: [String]
    let colors: [String]
    let printProfiles: [String]

    enum CodingKeys: String, CodingKey {
        case filamentTypes = "filament_types"
        case colors
        case printProfiles = "print_profiles"
    }
}
