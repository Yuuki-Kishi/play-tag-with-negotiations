//
//  Friend.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/11.
//

import Foundation

struct Friend: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.pertnerUserId == rhs.pertnerUserId
    }
    
    var id = UUID()
    var pertnerUserId: String
    var editedTime: Date
    var isFriend: Bool
    
    enum CodingKeys: String, CodingKey {
        case pertnerUserId, editedTime, isFriend
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.pertnerUserId = try container.decode(String.self, forKey: .pertnerUserId)
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .editedTime)
        if let date = formatter.date(from: dateString) {
            self.editedTime = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .editedTime, in: container, debugDescription: "Failed to decode editedTime.")
        }
        self.isFriend = try container.decode(Bool.self, forKey: .isFriend)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.pertnerUserId, forKey: .pertnerUserId)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: editedTime)
        try container.encode(dateString, forKey: .editedTime)
        try container.encode(self.isFriend, forKey: .isFriend)
    }
    
    init(pertnerUserId: String, editedTime: Date, isFriend: Bool) {
        self.id = UUID()
        self.pertnerUserId = pertnerUserId
        self.editedTime = editedTime
        self.isFriend = isFriend
    }
    
    init(pertnerUserId: String) {
        self.id = UUID()
        self.pertnerUserId = pertnerUserId
        self.editedTime = Date()
        self.isFriend = false
    }
    
    init() {
        self.id = UUID()
        self.pertnerUserId = "unknownUserId"
        self.editedTime = Date()
        self.isFriend = false
    }
}
