//
//  ChatViewModelTests.swift
//  AIChatBot
//
//  Created by Anju Anne Mathew on 26/05/2025.
//

import XCTest
@testable import AIChatBot

final class ChatViewModelTests: XCTestCase {
    var viewModel: ChatViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ChatViewModel()
        viewModel.messages = []  // Clear messages for test
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
// sendMessage() logic
    func testSendingMessageAddsUserMessage() {
        viewModel.inputText = "Hello"
        viewModel.sendMessage()

        XCTAssertEqual(viewModel.messages.count, 1)
        XCTAssertTrue(viewModel.messages.first?.isUser == true)
        XCTAssertEqual(viewModel.messages.first?.text, "Hello")
    }
    // Local state update tests

    // Preventing empty messages

    func testEmptyMessageDoesNotSend() {
        viewModel.inputText = "   "
        viewModel.sendMessage()

        XCTAssertEqual(viewModel.messages.count, 0)
    }
    //Loading Messages from UserDefaults
    func testLoadMessagesRestoresSavedMessages() {
        let sampleMessage = ChatMessage(text: "Hello", isUser: true, timestamp: Date())
        let data = try! JSONEncoder().encode([sampleMessage])
        UserDefaults.standard.set(data, forKey: "chatMessages")

        let vm = ChatViewModel()
        XCTAssertEqual(vm.messages.first?.text, "Hello")
    }
    //Saving Messages Works Correctly
    func testSaveMessagesStoresToUserDefaults() {
        viewModel.messages = [ChatMessage(text: "Test", isUser: true, timestamp: Date())]
        viewModel.saveMessages()

        let savedData = UserDefaults.standard.data(forKey: "chatMessages")
        XCTAssertNotNil(savedData)
    }


}
