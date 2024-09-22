//
//  Position.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import Foundation

struct PlayerPosition: Codable, Hashable {
    var phase: Int
    var x: Int
    var y: Int
    
    enum CodingKeys: String, CodingKey {
        case phase, x, y
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.phase = try container.decode(Int.self, forKey: .phase)
        self.x = try container.decode(Int.self, forKey: .x)
        self.y = try container.decode(Int.self, forKey: .y)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.phase, forKey: .phase)
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
    }
    
    init(phase: Int, x: Int, y: Int) {
        self.phase = phase
        self.x = x
        self.y = y
    }
    
    init(x: Int, y: Int) {
        self.phase = PlayerDataStore.shared.playingRoom.phaseNow
        self.x = x
        self.y = y
    }
    
    init() {
        self.phase = 0
        self.x = 0
        self.y = 0
    }
}
