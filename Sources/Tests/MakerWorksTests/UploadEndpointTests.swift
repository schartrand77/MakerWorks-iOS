import XCTest
@testable import MakerWorks

final class UploadEndpointTests: XCTestCase {
    func testUploadRequest() throws {
        let baseURL = URL(string: "https://api.makerworks.app")!
        let data = "hello".data(using: .utf8)!
        let boundary = "XYZ"
        let request = APIEndpoint.uploadModel(data: data, boundary: boundary).urlRequest(baseURL: baseURL)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.absoluteString, "https://api.makerworks.app/api/v1/upload/")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "multipart/form-data; boundary=\(boundary)")
        XCTAssertEqual(request.httpBody, data)
    }

    func testFilamentPickerRequest() throws {
        let baseURL = URL(string: "https://api.makerworks.app")!
        let request = APIEndpoint.filamentPicker.urlRequest(baseURL: baseURL)

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "https://api.makerworks.app/api/v1/filaments/picker/")
    }
}
