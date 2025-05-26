//
//  TypingIndicatorView.swift
//  AIChatBot
//
//  Created by Anju Anne Mathew on 24/05/2025.
//

import SwiftUI

struct TypingIndicatorView: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.secondary)
                    .opacity(animate ? 1 : 0.3)
                    .scaleEffect(animate ? 1 : 0.7)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}
