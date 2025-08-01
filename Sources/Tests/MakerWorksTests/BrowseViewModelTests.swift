import XCTest
import Combine
@testable import MakerWorks

final class BrowseViewModelTests: XCTestCase {
    var viewModel: BrowseViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = BrowseViewModel(client: MockNetworkClient())
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchModelsPopulatesList() {
        let expectation = XCTestExpectation(description: "models")

        viewModel.$models
            .dropFirst()
            .sink { models in
                if let first = models.first {
                    XCTAssertEqual(first.name, "Test Model")
                    XCTAssertEqual(first.description, "A description")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchModels()

        wait(for: [expectation], timeout: 1.0)
    }
}

private struct MockNetworkClient: NetworkClient {
    func request<T>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error> where T : Decodable {
        let model = Model(
            id: 1,
            name: "Test Model",
            uploader: "tester",
            uploadedAt: "2025-07-06T12:34:56Z",
            description: "A description",
            previewImage: nil,
            dimensions: nil,
            volumeCm3: nil,
            tags: nil,
            faceCount: nil,
            role: nil,
            category: nil
        )
        return Just([model] as! T)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func requestVoid(_ endpoint: APIEndpoint) -> AnyPublisher<Void, Error> {
        fatalError("not implemented")
    }
}
