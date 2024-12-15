//
//  IsCatchableStatus.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/12/09.
//

import Foundation

struct IsCatchableStatus: Codable, Hashable {
    var chaserUserId: String
    var isCatchable: Bool
    
    enum CodingKeys: String, CodingKey {
        case chaserUserId, isCatchable
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chaserUserId = try container.decode(String.self, forKey: .chaserUserId)
        self.isCatchable = try container.decode(Bool.self, forKey: .isCatchable)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chaserUserId, forKey: .chaserUserId)
        try container.encode(isCatchable, forKey: .isCatchable)
    }
    
    init(chaserUserId: String, isCatchable: Bool) {
        self.chaserUserId = chaserUserId
        self.isCatchable = isCatchable
    }
    
    init() {
        self.chaserUserId = "unknownUserId"
        self.isCatchable = false
    }
}
