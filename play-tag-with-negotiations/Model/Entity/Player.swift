//
//  Player.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import Foundation
import SwiftUI

struct Player: Codable, Hashable, Identifiable {
    var id = UUID()
    var userId: String
    var isHost: Bool
    var point: Int
    var enteredTime: Date
    var isDecided: Bool
    var playerPosition: PlayerPosition
    
    enum CodingKeys: String, CodingKey {
        case userId, isHost, point, enteredTime, isDecided, playerPosition
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isHost = try container.decode(Bool.self, forKey: .isHost)
        self.point = try container.decode(Int.self, forKey: .point)
        self.enteredTime = try container.decode(Date.self, forKey: .enteredTime)
        self.isDecided = try container.decode(Bool.self, forKey: .isDecided)
        self.playerPosition = try container.decode(PlayerPosition.self, forKey: .playerPosition)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.isHost, forKey: .isHost)
        try container.encode(self.point, forKey: .point)
        try container.encode(self.enteredTime, forKey: .enteredTime)
        try container.encode(self.isDecided, forKey: .isDecided)
        try container.encode(self.playerPosition, forKey: .playerPosition)
    }
    
    init(userId: String, isHost: Bool, point: Int, enteredTime: Date, isDecided: Bool, playerPosition: PlayerPosition) {
        self.id = UUID()
        self.userId = userId
        self.isHost = isHost
        self.point = point
        self.enteredTime = enteredTime
        self.isDecided = isDecided
        self.playerPosition = playerPosition
    }
    
    init(userId: String, isHost: Bool) {
        self.id = UUID()
        self.userId = userId
        self.isHost = isHost
        self.point = 0
        self.enteredTime = Date()
        self.isDecided = false
        self.playerPosition = PlayerPosition()
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
