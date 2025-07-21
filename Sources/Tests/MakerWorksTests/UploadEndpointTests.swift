import XCTest
@testable import MakerWorks

final class UploadEndpointTests: XCTestCase {
    func testUploadRequest() throws {
        let baseURL = URL(string: "http://localhost:8000")!
        let data = "hello".data(using: .utf8)!
        let boundary = "XYZ"
        let request = APIEndpoint.uploadModel(data: data, boundary: boundary).urlRequest(baseURL: baseURL)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.absoluteString, "http://localhost:8000/api/v1/upload/")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "multipart/form-data; boundary=\(boundary)")
        XCTAssertEqual(request.httpBody, data)
    }
}
