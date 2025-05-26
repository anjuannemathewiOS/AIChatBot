//
//  ChatMessage.swift
//  AIChatBot
//
//  Created by Anju Anne Mathew on 21/05/2025.
//

import Foundation


struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date
}
