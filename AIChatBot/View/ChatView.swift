//
//  ChatView.swift
//  AIChatBot
//
//  Created by Anju Anne Mathew on 21/05/2025.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    @State private var showUpArrow = true
    @State private var showDownArrow = false

    // Track content height & scroll view height for better offset detection
    @State private var contentHeight: CGFloat = 0
    @State private var scrollViewHeight: CGFloat = 0

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Image(systemName: "bolt.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)

                    Text("AI ChatBot")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.blue)

                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)

                GeometryReader { geo in
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.messages) { message in
                                    MessageRowView(message: message, isUser: message.isUser)
                                        .id(message.id)
                                }
                            }
                            .background(
                                GeometryReader { innerGeo -> Color in
                                    DispatchQueue.main.async {
                                        contentHeight = innerGeo.size.height
                                    }
                                    return Color.clear
                                }
                            )
                            .padding(.top, 10)
                            .background(
                                GeometryReader { scrollGeo -> Color in
                                    let offsetY = scrollGeo.frame(in: .named("scroll")).minY
                                    DispatchQueue.main.async {
                                        scrollViewHeight = scrollGeo.size.height
                                        updateArrowVisibility(offsetY: offsetY, contentHeight: contentHeight, scrollViewHeight: scrollViewHeight)
                                    }
                                    return Color.clear
                                }
                            )
                        }
                        .coordinateSpace(name: "scroll")
                        .onChange(of: viewModel.messages.count) { _ in
                            withAnimation {
                                if let last = viewModel.messages.last {
                                    proxy.scrollTo(last.id, anchor: .bottom)
                                }
                            }
                        }
                        .overlay(
                            VStack {
                                if showUpArrow {
                                    Button(action: {
                                        scrollToTop(proxy: proxy)
                                    }) {
                                        Image(systemName: "chevron.up.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.blue.opacity(0.7))
                                            .padding(.top, 10)
                                    }
                                }

                                Spacer()

                                if showDownArrow {
                                    Button(action: {
                                        scrollToBottom(proxy: proxy)
                                    }) {
                                        Image(systemName: "chevron.down.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.blue.opacity(0.7))
                                            .padding(.bottom, 10)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        )
                    }
                }

                HStack(spacing: 10) {
                    TextField("Say something...", text: $viewModel.inputText)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .onSubmit {
                            viewModel.sendMessage()
                        }

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
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .padding()
            }
        }
        .onAppear {
            viewModel.requestPermissions { granted in
                if !granted {
                    print("Speech or mic permission denied.")
                }
            }
        }
    }

    private func updateArrowVisibility(offsetY: CGFloat, contentHeight: CGFloat, scrollViewHeight: CGFloat) {
        let topThreshold: CGFloat = -10
        let bottomThreshold: CGFloat = -(contentHeight - scrollViewHeight) - 10

        if offsetY >= topThreshold {
            // At or near top
            showUpArrow = false
            showDownArrow = true
        } else if offsetY <= bottomThreshold {
            // At or near bottom
            showUpArrow = true
            showDownArrow = false
        } else {
            // Middle
            showUpArrow = true
            showDownArrow = true
        }
    }

    private func scrollToTop(proxy: ScrollViewProxy) {
        if let first = viewModel.messages.first {
            withAnimation {
                proxy.scrollTo(first.id, anchor: .top)
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let last = viewModel.messages.last {
            withAnimation {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
}

