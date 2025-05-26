//
//  ContentView.swift
//  AIChatBot
//
//  Created by Anju Anne Mathew on 21/05/2025.
//

import SwiftUI
import SwiftData

import SwiftUI

struct ContentView: View {
    var body: some View {
        ChatView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
