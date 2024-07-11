//
//  Friend.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/11.
//

import Foundation

struct Friend: Codable, Hashable, Identifiable {
    var id = UUID()
    var userId: String
    var requestTime: Date
    var isFriend: Bool
    
    enum CodingKeys: String, CodingKey {
        case userId, requestTime, isFriend
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.userId = try container.decode(String.self, forKey: .userId)
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .requestTime)
        if let date = formatter.date(from: dateString) {
            self.requestTime = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .requestTime, in: container, debugDescription: "Failed to decode creationDate.")
        }
        self.isFriend = try container.decode(Bool.self, forKey: .isFriend)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: requestTime)
        try container.encode(dateString, forKey: .requestTime)
        try container.encode(self.isFriend, forKey: .isFriend)
    }
    
    init(userId: String, requestTime: Date, isFriend: Bool) {
        self.id = UUID()
        self.userId = userId
        self.requestTime = requestTime
        self.isFriend = isFriend
    }
    
    init(userId: String) {
        self.id = UUID()
        self.userId = userId
        self.requestTime = Date()
        self.isFriend = false
    }
    
    init() {
        self.id = UUID()
        self.userId = "unknownUserId"
        self.requestTime = Date()
        self.isFriend = false
    }
}
