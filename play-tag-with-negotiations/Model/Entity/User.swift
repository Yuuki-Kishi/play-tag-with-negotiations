//
//  User.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/16.
//

import Foundation

struct User: Hashable, Identifiable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    var id = UUID()
    var userId: String
    var userName: String
    var iconUrl: String
    var pronoun: String
    
    init(userId: String, userName: String, iconUrl: String, pronoun: String) {
        self.id = UUID()
        self.userId = userId
        self.userName = userName
        self.iconUrl = iconUrl
        self.pronoun = pronoun
    }
    
    init(userId: String) {
        self.id = UUID()
        self.userId = userId
        self.userName = ""
        self.iconUrl = ""
        self.pronoun = ""
    }
    
    init() {
        self.id = UUID()
        self.userId = "unknownUserId"
        self.userName = "unknown"
        self.iconUrl = "unknownURL"
        self.pronoun = "Who am I?"
    }
}
