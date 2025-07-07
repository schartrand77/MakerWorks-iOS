//
//  Estimate.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation

/// Represents a print estimate returned from the backend API.
struct Estimate: Codable {
    /// Estimated print time in minutes
    let estimatedTimeMinutes: Double
    /// Estimated cost in US dollars
    let estimatedCostUSD: Double
}
