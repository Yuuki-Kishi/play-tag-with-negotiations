//
//  Player.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import Foundation

struct Player: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    var id = UUID()
    var userId: String
    var isHost: Bool
    var point: Int
    var enteredTime: Date
    var isChaser: Bool
    var isDecided: Bool
    var move: [PlayerPosition]
    
    enum CodingKeys: String, CodingKey {
        case userId, isHost, point, enteredTime, isChaser, isDecided, move
    }
    
    enum PlayerPositionKeys: String, CodingKey {
        case x, y
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isHost = try container.decode(Bool.self, forKey: .isHost)
        self.point = try container.decode(Int.self, forKey: .point)
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .enteredTime)
        if let date = formatter.date(from: dateString) {
            self.enteredTime = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .enteredTime, in: container, debugDescription: "Failed to decode creationDate.")
        }
        self.isChaser = try container.decode(Bool.self, forKey: .isChaser)
        self.isDecided = try container.decode(Bool.self, forKey: .isDecided)
        self.move = try container.decode([PlayerPosition].self, forKey: .move)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.isHost, forKey: .isHost)
        try container.encode(self.point, forKey: .point)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: enteredTime)
        try container.encode(dateString, forKey: .enteredTime)
        try container.encode(self.isChaser, forKey: .isChaser)
        try container.encode(self.isDecided, forKey: .isDecided)
        try container.encode(self.move, forKey: .move)
//        var playerPlosition = container.nestedContainer(keyedBy: PlayerPositionKeys.self, forKey: .playerPosition)
//        try playerPlosition.encode(self.playerPosition.x, forKey: .x)
//        try playerPlosition.encode(self.playerPosition.y, forKey: .y)
    }
    
    init(userId: String, isHost: Bool, point: Int, enteredTime: Date, isChaser: Bool, isDecided: Bool, move: [PlayerPosition]) {
        self.id = UUID()
        self.userId = userId
        self.isHost = isHost
        self.point = point
        self.enteredTime = enteredTime
        self.isChaser = isChaser
        self.isDecided = isDecided
        self.move = move
    }
    
    init(userId: String, isHost: Bool) {
        self.id = UUID()
        self.userId = userId
        self.isHost = isHost
        self.point = 0
        self.enteredTime = Date()
        self.isChaser = false
        self.isDecided = false
        self.move = []
    }
    
    init() {
        self.id = UUID()
        self.userId = "unknownUserId"
        self.isHost = false
        self.point = 0
        self.enteredTime = Date()
        self.isChaser = false
        self.isDecided = true
        self.move = []
    }
}
