//
//  Friend.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/11.
//

import Foundation

struct Friend: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    var id = UUID()
    var userId: String
    var editedTime: Date
    var isFriend: Bool
    
    enum CodingKeys: String, CodingKey {
        case userId, editedTime, isFriend
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.userId = try container.decode(String.self, forKey: .userId)
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .editedTime)
        if let date = formatter.date(from: dateString) {
            self.editedTime = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .editedTime, in: container, debugDescription: "Failed to decode creationDate.")
        }
        self.isFriend = try container.decode(Bool.self, forKey: .isFriend)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: editedTime)
        try container.encode(dateString, forKey: .editedTime)
        try container.encode(self.isFriend, forKey: .isFriend)
    }
    
    init(userId: String, editedTime: Date, isFriend: Bool) {
        self.id = UUID()
        self.userId = userId
        self.editedTime = editedTime
        self.isFriend = isFriend
    }
    
    init(userId: String) {
        self.id = UUID()
        self.userId = userId
        self.editedTime = Date()
        self.isFriend = false
    }
    
    init() {
        self.id = UUID()
        self.userId = "unknownUserId"
        self.editedTime = Date()
        self.isFriend = false
    }
}
