//
//  Filament.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation

/// Represents an individual spool of printing filament
struct Filament: Codable, Identifiable {
    /// Unique identifier for this filament
    let id: Int
    /// Material type (e.g. PLA, PETG)
    let type: String
    /// Hex color code for the filament
    let colorHex: String
}
