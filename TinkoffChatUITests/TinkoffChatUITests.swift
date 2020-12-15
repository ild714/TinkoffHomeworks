//
//  TinkoffChatUITests.swift
//  TinkoffChatUITests
//
//  Created by Ildar on 11/30/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import XCTest
import FBSnapshotTestCase

class TinkoffChatUITests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        
    }
    
    func testProfileVC() throws {
        // Arrange
        let app = XCUIApplication()
        
        // Act
        app.launch()
        app.navigationBars["Channels"].buttons["user"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        element.children(matching: .button).matching(identifier: "Edit").element(boundBy: 1).tap()
        
        let textField = app.textFields["Name"]
        let textView = element.children(matching: .textView).element
        
        // Assert
        XCTAssertTrue(textField.exists)
        XCTAssertTrue(textView.exists)
    }
}
