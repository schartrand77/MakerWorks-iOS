//
//  EstimateViewModelTests.swift
//  MakerWorksTests
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import XCTest
import Combine
@testable import MakerWorks

final class EstimateViewModelTests: XCTestCase {
    var viewModel: EstimateViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = EstimateViewModel(client: MockNetworkClient())
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testValidEstimateInputs() {
        viewModel.x_mm = 100
        viewModel.y_mm = 100
        viewModel.z_mm = 100
        viewModel.filamentType = "PLA"
        viewModel.filamentColors = ["#FF0000"]
        viewModel.printProfile = "standard"

        let expectation = XCTestExpectation(description: "Estimate completes")

        viewModel.$estimateResult
            .dropFirst()
            .sink { result in
                if let result = result {
                    XCTAssertGreaterThan(result.estimatedCostUSD, 0)
                    XCTAssertGreaterThan(result.estimatedTimeMinutes, 0)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.estimate()

        wait(for: [expectation], timeout: 2.0)
    }

    func testInvalidDimensions() {
        viewModel.x_mm = 0
        viewModel.estimate()

        XCTAssertEqual(viewModel.errorMessage, "All dimensions must be greater than 0.")
    }

    func testNoFilamentType() {
        viewModel.filamentType = ""
        viewModel.estimate()

        XCTAssertEqual(viewModel.errorMessage, "Please select a filament type.")
    }

    func testNoColors() {
        viewModel.filamentColors = []
        viewModel.estimate()

        XCTAssertEqual(viewModel.errorMessage, "Please select at least one filament color.")
    }
}

// MARK: - Mock Network Client

struct MockNetworkClient: NetworkClient {
    func request<T>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error> where T : Decodable {
        let response = EstimateResponse(estimated_time_minutes: 120.0, estimated_cost_usd: 15.0)
        return Just(response as! T)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
