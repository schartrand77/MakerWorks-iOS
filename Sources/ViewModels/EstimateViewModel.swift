//
//  EstimateViewModel.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Combine

struct EstimateResult {
    let estimatedTimeMinutes: Double
    let estimatedCostUSD: Double
}

final class EstimateViewModel: ObservableObject {
    // Inputs
    @Published var x_mm: Double = 50.0
    @Published var y_mm: Double = 50.0
    @Published var z_mm: Double = 50.0
    @Published var filamentType: String = ""
    @Published var filamentColors: [String] = []
    @Published var printProfile: String = "standard"
    @Published var customText: String = ""
    @Published var modelID: Int = 1

    // Outputs
    @Published var estimateResult: EstimateResult?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let availableFilamentTypes = ["PLA", "PLA MATTE", "PETG"]
    let availableColors = [
        "#FF0000", "#00FF00", "#0000FF", "#FFFF00",
        "#FF00FF", "#00FFFF", "#000000", "#FFFFFF"
    ]
    let availablePrintProfiles = ["standard", "quality", "elite"]

    private var cancellables = Set<AnyCancellable>()
    private let client: NetworkClient

    init(client: NetworkClient = DefaultNetworkClient.shared) {
        self.client = client
        filamentType = availableFilamentTypes.first ?? ""
    }

    func loadFilamentData() {
        // optionally fetch availableFilamentTypes & colors from backend
        // for now uses hardcoded lists
    }

    /// Builds the request payload for the estimate call
    func buildPayload() -> [String: Any] {
        var payload: [String: Any] = [:]
        payload["model_id"] = modelID
        payload["x_mm"] = x_mm
        payload["y_mm"] = y_mm
        payload["z_mm"] = z_mm
        payload["filament_type"] = filamentType
        payload["filament_colors"] = filamentColors
        payload["print_profile"] = printProfile
        if !customText.isEmpty {
            payload["custom_text"] = customText
        }
        return payload
    }

    func estimate() {
        guard x_mm > 0, y_mm > 0, z_mm > 0 else {
            errorMessage = "All dimensions must be greater than 0."
            return
        }
        guard !filamentType.isEmpty else {
            errorMessage = "Please select a filament type."
            return
        }
        guard !filamentColors.isEmpty else {
            errorMessage = "Please select at least one filament color."
            return
        }

        isLoading = true
        errorMessage = nil
        estimateResult = nil

        var request = APIEndpoint.estimate.urlRequest(baseURL: DefaultNetworkClient.shared.baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = buildPayload()

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            return
        }

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: EstimateResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                self.estimateResult = EstimateResult(
                    estimatedTimeMinutes: response.estimated_time_minutes,
                    estimatedCostUSD: response.estimated_cost_usd
                )
            })
            .store(in: &cancellables)
    }
}

// MARK: - API Response Model

struct EstimateResponse: Codable {
    let estimated_time_minutes: Double
    let estimated_cost_usd: Double
}
