//
//  LoginUITests.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import XCTest

final class LoginUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Verifies that all basic login screen elements are present when the app launches.
    func testLoginScreenElementsExist() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Welcome to MakerWorks"].exists)
        XCTAssertTrue(app.textFields["Server Address"].exists)
        XCTAssertTrue(app.textFields["Username"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        XCTAssertTrue(app.buttons["Login"].exists)
    }
}


