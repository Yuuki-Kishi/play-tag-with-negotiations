//
//  Position.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import Foundation

struct PlayerPosition: Codable, Hashable, Identifiable {
    var id: UUID
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.id = UUID()
        self.x = x
        self.y = y
    }
    
    init() {
        self.id = UUID()
        self.x = 0
        self.y = 0
    }
}
