//
//  EstimateViewModelTests.swift
//  MakerWorksTests
//
//  Created by Stephen Chartrand on 2025-07-11.
//

import XCTest
import Combine
@testable import MakerWorks

final class EstimateViewModelTests: XCTestCase {

    var viewModel: EstimateViewModel!

    override func setUp() {
        super.setUp()
        viewModel = EstimateViewModel(client: MockNetworkClient())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialValues() {
        XCTAssertEqual(viewModel.x_mm, 50.0)
        XCTAssertEqual(viewModel.y_mm, 50.0)
        XCTAssertEqual(viewModel.z_mm, 50.0)
        XCTAssertEqual(viewModel.filamentType, "PLA") // assuming PLA is first in list
        XCTAssertTrue(viewModel.filamentColors.isEmpty)
        XCTAssertEqual(viewModel.printProfile, "standard")
    }

    func testInvalidDimensionsShowsError() {
        viewModel.x_mm = 0
        viewModel.estimate()
        XCTAssertEqual(viewModel.errorMessage, "All dimensions must be greater than 0.")
    }

    func testNoFilamentTypeShowsError() {
        viewModel.filamentType = ""
        viewModel.estimate()
        XCTAssertEqual(viewModel.errorMessage, "Please select a filament type.")
    }

    func testNoFilamentColorsShowsError() {
        viewModel.filamentColors = []
        viewModel.estimate()
        XCTAssertEqual(viewModel.errorMessage, "Please select at least one filament color.")
    }

    func testEstimateReturnsResult() {
        viewModel.filamentColors = ["#FF0000"]
        viewModel.estimate()
        
        // Give the async task a short moment
        let expectation = XCTestExpectation(description: "Estimate result received")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewModel.estimateResult)
            XCTAssertEqual(self.viewModel.estimateResult?.estimatedTimeMinutes, 30.0)
            XCTAssertEqual(self.viewModel.estimateResult?.estimatedCostUSD, 10.0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock NetworkClient

final class MockNetworkClient: NetworkClient {
    func request(_ request: URLRequest) -> AnyPublisher<Data, URLError> {
        let response = EstimateResponse(
            estimated_time_minutes: 30.0,
            estimated_cost_usd: 10.0
        )
        let data = try! JSONEncoder().encode(response)
        return Just(data)
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
