import XCTest
@testable import MakerWorks

final class AsyncNetworkClientTests: XCTestCase {
    func testAsyncRequestDecodes() async throws {
        let stubJSON = "{" + "\"foo\":\"bar\"" + "}"
        MockURLProtocol.stubResponseData = stubJSON.data(using: .utf8)
        MockURLProtocol.statusCode = 200

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let client = DefaultNetworkClient(baseURL: URL(string: "https://example.com")!, session: session, authenticator: Authenticator.shared)

        struct Response: Decodable { let foo: String }
        let result: Response = try await client.request(.currentUser)
        XCTAssertEqual(result.foo, "bar")
    }
}

private class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var statusCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let response = HTTPURLResponse(url: request.url!, statusCode: Self.statusCode, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let data = Self.stubResponseData {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
