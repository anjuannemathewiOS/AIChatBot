//
//  ChatView.swift
//  AIChatBot
//
//  Created by Anju Anne Mathew on 21/05/2025.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("AI ChatBot")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemBackground).shadow(radius: 1))

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageRowView(message: message, isUser: message.isUser)
                                .id(message.id)
                        }
                    }
                    .padding(.top, 10)
                }
                .background(Color(UIColor.systemGroupedBackground))
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation(.easeOut(duration: 0.3)) {
                        if let last = viewModel.messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Input
            HStack(spacing: 10) {
                TextField("Type a message", text: $viewModel.inputText)
                    .padding(12)
                    .background(Color(UIColor.systemGray6))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.gray, lineWidth: 1))

                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(viewModel.inputText.isEmpty ? Color.gray : Color.blue)
                        .clipShape(Circle())
                }
                .disabled(viewModel.inputText.isEmpty)

                Button(action: {
                    if viewModel.isRecording {
                        viewModel.stopRecording()
                    } else {
                        try? viewModel.startRecording()
                    }
                }) {
                    Image(systemName: viewModel.isRecording ? "mic.circle.fill" : "mic.circle")
                        .font(.system(size: 26))
                        .foregroundColor(viewModel.isRecording ? .red : .blue)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground).shadow(radius: 2))
        }
        .onAppear {
            viewModel.requestPermissions { granted in
                if !granted {
                    print("Speech or mic permission denied.")
                }
            }
        }
    }
}
