//
//  Item.swift
//  AIChatBot
//
//  Created by Anju Anne Mathew on 21/05/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
