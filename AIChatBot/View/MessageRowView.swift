//
//  MessageRowView.swift
//  AIChatBot
//
//  Created by Anju Anne Mathew on 21/05/2025.
//

import SwiftUI

struct MessageRowView: View {
    let message: ChatMessage
    let isUser: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            if !isUser {
                avatar
            }

            messageBubble

            if isUser {
                avatar
            }
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }

    private var avatar: some View {
        Image(isUser ? "user_avatar" : "bot_avatar") 
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 32, height: 32)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
    }

    private var messageBubble: some View {
        Text(message.text)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isUser ? Color.blue.opacity(0.8) : Color.gray.opacity(0.2))
            .foregroundColor(isUser ? .white : .primary)
            .cornerRadius(22)
            .multilineTextAlignment(.leading)
    }
}
