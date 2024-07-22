//
//  Position.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import Foundation

struct PlayerPosition: Codable, Hashable {
//    static func == (lhs: PlayerPosition, rhs: PlayerPosition) -> Bool {
//        return lhs.x == rhs.x && lhs.y == rhs.y
//    }
//    
    var x: Int
    var y: Int
    
    enum CodingKeys: String, CodingKey {
        case playerPosition
    }
    
    enum PlayerPositionKeys: String, CodingKey {
        case x, y
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let playerPosition = try container.nestedContainer(keyedBy: PlayerPositionKeys.self, forKey: .playerPosition)
        self.x = try playerPosition.decode(Int.self, forKey: .x)
        self.y = try playerPosition.decode(Int.self, forKey: .y)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var playerPlosition = container.nestedContainer(keyedBy: PlayerPositionKeys.self, forKey: .playerPosition)
        try playerPlosition.encode(self.x, forKey: .x)
        try playerPlosition.encode(self.y, forKey: .y)
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init() {
        self.x = 0
        self.y = 0
    }
}
