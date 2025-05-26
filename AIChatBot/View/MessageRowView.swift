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
        HStack(alignment: .bottom, spacing: 8) {
            if !isUser {
                avatar
            }
            
            Text(message.text)
                .padding(14)
                .background(isUser ? Color.blue : Color.white)
                .foregroundColor(isUser ? .white : .primary)
                .font(.system(size: 16))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: isUser ? .blue.opacity(0.3) : .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .frame(maxWidth: 280, alignment: isUser ? .trailing : .leading)
            
            if isUser {
                avatar
            }
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private var avatar: some View {
        Image(systemName: isUser ? "person.crop.circle.fill" : "bolt.circle.fill")
            .resizable()
            .frame(width: 32, height: 32)
            .foregroundColor(isUser ? .blue : .gray)
    }
}
