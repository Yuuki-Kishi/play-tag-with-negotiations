//
//  Notice.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/21.
//

import Foundation

struct Notice: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Notice, rhs: Notice) -> Bool {
        return lhs.userId == rhs.userId
    }
    var id = UUID()
    var noticeId: UUID
    var userId: String
    var sendUser: User
    var sendTime: Date
    var roomId: String
    var isChecked: Bool
    var noticeType: NoticeType
    
    enum NoticeType: String {
        case friend
        case invite
        case unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case noticeId, userId, sendTime, roomId, isChecked, noticeType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        let noticeIdString = try container.decode(String.self, forKey: .noticeId)
        if let noticeId = UUID(uuidString: noticeIdString) {
            self.noticeId = noticeId
        } else {
            throw DecodingError.dataCorruptedError(forKey: .noticeId, in: container, debugDescription: "Failed to decode noticeId.")
        }
        self.userId = try container.decode(String.self, forKey: .userId)
        self.sendUser = User()
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .sendTime)
        if let date = formatter.date(from: dateString) {
            self.sendTime = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .sendTime, in: container, debugDescription: "Failed to decode creationDate.")
        }
        self.roomId = try container.decode(String.self, forKey: .roomId)
        self.isChecked = try container.decode(Bool.self, forKey: .isChecked)
        let type = try container.decode(String.self, forKey: .noticeType)
        self.noticeType = NoticeType(rawValue: type) ?? .unknown
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.noticeId, forKey: .noticeId)
        try container.encode(self.userId, forKey: .userId)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: sendTime)
        try container.encode(dateString, forKey: .sendTime)
        try container.encode(self.roomId, forKey: .roomId)
        try container.encode(self.isChecked, forKey: .isChecked)
        try container.encode(self.noticeType.rawValue, forKey: .noticeType)
    }
    
    init(noticeId: UUID, userId: String, user: User, sendTime: Date, roomId: String, isChecked: Bool, noticeType: NoticeType) {
        self.id = UUID()
        self.noticeId = noticeId
        self.userId = userId
        self.sendUser = user
        self.sendTime = sendTime
        self.roomId = roomId
        self.isChecked = isChecked
        self.noticeType = noticeType
    }
    
    init(userId: String) {
        self.id = UUID()
        self.noticeId = UUID()
        self.userId = userId
        self.sendUser = User()
        self.sendTime = Date()
        self.roomId = ""
        self.isChecked = false
        self.noticeType = .friend
    }
    
    init(userId: String, roomId: String) {
        self.id = UUID()
        self.noticeId = UUID()
        self.userId = userId
        self.sendUser = User()
        self.sendTime = Date()
        self.roomId = roomId
        self.isChecked = false
        self.noticeType = .invite
    }
    
    init() {
        self.id = UUID()
        self.noticeId = UUID()
        self.userId = "unknownUserId"
        self.sendUser = User()
        self.sendTime = Date()
        self.roomId = ""
        self.isChecked = false
        self.noticeType = .unknown
    }
}
