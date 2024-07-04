//
//  Player.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import Foundation
import SwiftUI

struct Player: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    var id = UUID()
    var userId: String
    var isHost: Bool
    var point: Int
    var enteredTime: Date
    var isDecided: Bool
    var playerPosition: PlayerPosition
        
    init(userId: String, isHost: Bool, point: Int, enteredTime: Date, isDecided: Bool, playerPosition: PlayerPosition) {
        self.id = UUID()
        self.userId = userId
        self.isHost = isHost
        self.point = point
        self.enteredTime = enteredTime
        self.isDecided = isDecided
        self.playerPosition = playerPosition
    }
    
    init() {
        self.id = UUID()
        self.userId = "unknownUserId"
        self.isHost = false
        self.point = 0
        self.enteredTime = Date()
        self.isDecided = true
        self.playerPosition = PlayerPosition()
    }
}
