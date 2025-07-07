import XCTest
@testable import MakerWorks

final class AuthTests: XCTestCase {
    func testExchangeCodeEndpointRequest() throws {
        let baseURL = URL(string: "https://example.com")!
        let request = APIEndpoint.exchangeCode("abc123").urlRequest(baseURL: baseURL)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.absoluteString, "https://example.com/api/v1/auth/exchange/")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")

        if let body = request.httpBody,
           let json = try JSONSerialization.jsonObject(with: body) as? [String: String] {
            XCTAssertEqual(json["code"], "abc123")
        } else {
            XCTFail("Request body missing")
        }
    }
}
