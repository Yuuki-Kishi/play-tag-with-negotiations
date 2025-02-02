//
//  User.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/16.
//

import Foundation

struct User: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    var id = UUID()
    var userId: String
    var userName: String
    var creationDate: Date
    var iconUrl: String
    var iconData: Data?
    var friendUsers: [String]
    var profile: String
    
    enum CodingKeys: String, CodingKey {
        case userId, userName, creationDate, iconUrl, iconData, friendUsers, profile
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.userId = try container.decode(String.self, forKey: .userId)
        self.userName = try container.decode(String.self, forKey: .userName)
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .creationDate)
        if let date = formatter.date(from: dateString) {
            self.creationDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .creationDate, in: container, debugDescription: "Failed to decode creationDate.")
        }
        self.iconUrl = try container.decode(String.self, forKey: .iconUrl)
        self.iconData = nil
        self.friendUsers = try container.decodeIfPresent([String].self, forKey: .friendUsers) ?? []
        self.profile = try container.decode(String.self, forKey: .profile)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.userName, forKey: .userName)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: creationDate)
        try container.encode(dateString, forKey: .creationDate)
        try container.encode(self.iconUrl, forKey: .iconUrl)
        try container.encode(self.friendUsers, forKey: .friendUsers)
        try container.encode(self.profile, forKey: .profile)
    }
    
    init(userId: String, userName: String, creationDate: Date, iconUrl: String, iconData: Data?, friendUsers: [String], profile: String) {
        self.id = UUID()
        self.userId = userId
        self.userName = userName
        self.creationDate = creationDate
        self.iconUrl = iconUrl
        self.iconData = iconData
        self.friendUsers = friendUsers
        self.profile = profile
    }
    
    init(userId: String, creationDate: Date) {
        self.id = UUID()
        self.userId = userId
        self.userName = "未設定"
        self.creationDate = creationDate
        self.iconUrl = "default"
        self.iconData = nil
        self.friendUsers = []
        self.profile = "未設定"
    }
    
    init() {
        self.id = UUID()
        self.userId = "unknownUserId"
        self.userName = "unknown"
        self.creationDate = Date()
        self.iconUrl = "default"
        self.iconData = nil
        self.friendUsers = []
        self.profile = "Who am I?"
    }
}
