//
//  Player.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import Foundation

struct Player: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.playerUserId == rhs.playerUserId
    }
    
    var id = UUID()
    var playerUserId: String
    var player: User
    var isHost: Bool
    var point: Int
    var enteredTime: Date
    var isChaser: Bool
    var isDecided: Bool
    var isCaptured: Bool
    var move: [PlayerPosition]
    
    enum CodingKeys: String, CodingKey {
        case playerUserId, isHost, point, enteredTime, isChaser, isDecided, isCaptured, move
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.playerUserId = try container.decode(String.self, forKey: .playerUserId)
        self.player = User()
        self.isHost = try container.decode(Bool.self, forKey: .isHost)
        self.point = try container.decode(Int.self, forKey: .point)
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .enteredTime)
        if let date = formatter.date(from: dateString) {
            self.enteredTime = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .enteredTime, in: container, debugDescription: "Failed to decode enteredTIme.")
        }
        self.isChaser = try container.decode(Bool.self, forKey: .isChaser)
        self.isDecided = try container.decode(Bool.self, forKey: .isDecided)
        self.isCaptured = try container.decode(Bool.self, forKey: .isCaptured)
        self.move = try container.decode([PlayerPosition].self, forKey: .move)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.playerUserId, forKey: .playerUserId)
        try container.encode(self.isHost, forKey: .isHost)
        try container.encode(self.point, forKey: .point)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: enteredTime)
        try container.encode(dateString, forKey: .enteredTime)
        try container.encode(self.isChaser, forKey: .isChaser)
        try container.encode(self.isDecided, forKey: .isDecided)
        try container.encode(self.isCaptured, forKey: .isCaptured)
        try container.encode(self.move, forKey: .move)
    }
    
    init(playerUserId: String, player: User, isHost: Bool, point: Int, enteredTime: Date, isChaser: Bool, isDecided: Bool, isCaptured: Bool, move: [PlayerPosition]) {
        self.id = UUID()
        self.playerUserId = playerUserId
        self.player = User()
        self.isHost = isHost
        self.point = point
        self.enteredTime = enteredTime
        self.isChaser = isChaser
        self.isDecided = isDecided
        self.isCaptured = isCaptured
        self.move = move
    }
    
    init(playerUserId: String, isHost: Bool) {
        self.id = UUID()
        self.playerUserId = playerUserId
        self.player = User()
        self.isHost = isHost
        self.point = 0
        self.enteredTime = Date()
        self.isChaser = false
        self.isDecided = false
        self.isCaptured = false
        self.move = []
    }
    
    init() {
        self.id = UUID()
        self.playerUserId = "unknownUserId"
        self.player = User()
        self.isHost = false
        self.point = 0
        self.enteredTime = Date()
        self.isChaser = false
        self.isDecided = true
        self.isCaptured = false
        self.move = []
    }
}
