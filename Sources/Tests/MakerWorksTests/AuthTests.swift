import XCTest
@testable import MakerWorks

final class AuthTests: XCTestCase {
    func testExchangeCodeEndpointRequest() throws {
        let baseURL = URL(string: "https://api.makerworks.app")!
        let request = APIEndpoint.exchangeCode("abc123").urlRequest(baseURL: baseURL)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.absoluteString, "https://api.makerworks.app/api/v1/auth/exchange/")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")

        if let body = request.httpBody,
           let json = try JSONSerialization.jsonObject(with: body) as? [String: String] {
            XCTAssertEqual(json["code"], "abc123")
        } else {
            XCTFail("Request body missing")
        }
    }

    func testAdminUnlockEndpointRequest() throws {
        let baseURL = URL(string: "https://api.makerworks.app")!
        let request = APIEndpoint.adminUnlock(email: "user@example.com").urlRequest(baseURL: baseURL)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.absoluteString, "https://api.makerworks.app/api/v1/admin/unlock/")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")

        if let body = request.httpBody,
           let json = try JSONSerialization.jsonObject(with: body) as? [String: String] {
            XCTAssertEqual(json["email"], "user@example.com")
        } else {
            XCTFail("Request body missing")
        }
    }
}
