//
//  AIChatBotUITests.swift
//  AIChatBotUITests
//
//  Created by Anju Anne Mathew on 21/05/2025.
//

import XCTest

final class AIChatBotUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Clean up if needed
    }

    func testMessageInputAndSendButton() throws {
        let messageField = app.textFields["MessageInputField"]
        XCTAssertTrue(messageField.exists, "TextField should exist")

        messageField.tap()
        messageField.typeText("Hello GPT!")

        let sendButton = app.buttons["SendButton"]
        XCTAssertTrue(sendButton.exists, "Send button should exist")
        XCTAssertTrue(sendButton.isEnabled, "Send button should be enabled after typing")

        sendButton.tap()

        // Wait for message to appear
        let sentMessage = app.staticTexts["Hello GPT!"]
        let exists = sentMessage.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Sent message should appear in chat")
    }
    func testArrowButtonsVisibilityAndTapping() throws {
        let app = XCUIApplication()
        app.launch()

        // Initially, only up arrow should be visible (since we are at bottom)
        let upArrow = app.buttons["ScrollToTopButton"]
        let downArrow = app.buttons["ScrollDownButton"]
        
        XCTAssertTrue(upArrow.waitForExistence(timeout: 5), "Up arrow should be visible initially")
        XCTAssertFalse(downArrow.exists, "Down arrow should NOT be visible initially")

        // Tap up arrow to scroll to top
        upArrow.tap()

        // Now down arrow should appear and up arrow disappear after scrolling to top
        XCTAssertTrue(downArrow.waitForExistence(timeout: 5), "Down arrow should be visible after scrolling up")
        XCTAssertFalse(upArrow.exists, "Up arrow should NOT be visible after scrolling to top")

        // Tap down arrow to scroll back to bottom
        downArrow.tap()

        // Up arrow should reappear after scrolling to bottom
        XCTAssertTrue(upArrow.waitForExistence(timeout: 5), "Up arrow should be visible after scrolling down")
        XCTAssertFalse(downArrow.exists, "Down arrow should NOT be visible after scrolling down")
    }

    func testScrollToTopArrowAppearsAfterScrolling() throws {
        // Wait for messages to load and scroll view to appear
        sleep(2)

        // Swipe up to scroll down first (this hides the up arrow initially)
        app.swipeUp()
        sleep(1)

        // Then swipe down to simulate scrolling to top
        app.swipeDown()
        sleep(1)

        let scrollToTopButton = app.buttons["ScrollToTopButton"]
        XCTAssertTrue(scrollToTopButton.exists, "Scroll-to-top button should appear after scrolling")
        
    }
    func testScrollToBottomButton() throws {
        // ... prepare by scrolling up ...
        let scrollDownButton = app.buttons["ScrollDownButton"]
        XCTAssertTrue(scrollDownButton.exists)
        scrollDownButton.tap()
    }
}
