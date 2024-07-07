//
//  User.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/16.
//

import Foundation

struct User: Hashable, Identifiable, Equatable, Codable {
//    static func == (lhs: User, rhs: User) -> Bool {
//        return lhs.userId == rhs.userId
//    }
    
    var id = UUID()
    var userId: String
    var userName: String
    var creationDate: Date
    var iconUrl: String
    var pronoun: String
    
    enum CodingKeys: String, CodingKey {
        case userId, userName, creationDate, iconUrl, pronoun
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.userId = try container.decode(String.self, forKey: .userId)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        self.iconUrl = try container.decode(String.self, forKey: .iconUrl)
        self.pronoun = try container.decode(String.self, forKey: .pronoun)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(userName, forKey: .userName)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(iconUrl, forKey: .iconUrl)
        try container.encode(pronoun, forKey: .pronoun)
    }
    
    init(userId: String, userName: String, creationDate: Date, iconUrl: String, pronoun: String) {
        self.id = UUID()
        self.userId = userId
        self.userName = userName
        self.creationDate = creationDate
        self.iconUrl = iconUrl
        self.pronoun = pronoun
    }
    
    init(userId: String, creationDate: Date) {
        self.id = UUID()
        self.userId = userId
        self.userName = "未設定"
        self.creationDate = creationDate
        self.iconUrl = ""
        self.pronoun = "未設定"
    }
    
    init() {
        self.id = UUID()
        self.userId = "unknownUserId"
        self.userName = "unknown"
        self.creationDate = Date()
        self.iconUrl = "unknownURL"
        self.pronoun = "Who am I?"
    }
}
