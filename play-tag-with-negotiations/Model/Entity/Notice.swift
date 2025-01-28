//
//  Notice.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/21.
//

import Foundation

struct Notice: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Notice, rhs: Notice) -> Bool {
        return lhs.noticeId == rhs.noticeId
    }
    var id = UUID()
    var noticeId: String
    var senderUserId: String
    var sendUser: User
    var sendDate: Date
    var roomId: String
    var isChecked: Bool
    var noticeType: NoticeType
    
    enum NoticeType: String {
        case friendShip, invite, unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case noticeId, senderUserId, sendDate, roomId, isChecked, noticeType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.noticeId = try container.decode(String.self, forKey: .noticeId)
        self.senderUserId = try container.decode(String.self, forKey: .senderUserId)
        self.sendUser = User()
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .sendDate)
        if let date = formatter.date(from: dateString) {
            self.sendDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .sendDate, in: container, debugDescription: "Failed to decode sendDate.")
        }
        self.roomId = try container.decode(String.self, forKey: .roomId)
        self.isChecked = try container.decode(Bool.self, forKey: .isChecked)
        let type = try container.decode(String.self, forKey: .noticeType)
        self.noticeType = NoticeType(rawValue: type) ?? .unknown
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.noticeId, forKey: .noticeId)
        try container.encode(self.senderUserId, forKey: .senderUserId)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: sendDate)
        try container.encode(dateString, forKey: .sendDate)
        try container.encode(self.roomId, forKey: .roomId)
        try container.encode(self.isChecked, forKey: .isChecked)
        try container.encode(self.noticeType.rawValue, forKey: .noticeType)
    }
    
    init(noticeId: String, senderUserId: String, user: User, sendDate: Date, roomId: String, isChecked: Bool, noticeType: NoticeType) {
        self.id = UUID()
        self.noticeId = noticeId
        self.senderUserId = senderUserId
        self.sendUser = user
        self.sendDate = sendDate
        self.roomId = roomId
        self.isChecked = isChecked
        self.noticeType = noticeType
    }
    
    init(senderUserId: String) {
        self.id = UUID()
        self.noticeId = UUID().uuidString
        self.senderUserId = senderUserId
        self.sendUser = User()
        self.sendDate = Date()
        self.roomId = ""
        self.isChecked = false
        self.noticeType = .friendShip
    }
    
    init(senderUserId: String, roomId: String) {
        self.id = UUID()
        self.noticeId = UUID().uuidString
        self.senderUserId = senderUserId
        self.sendUser = User()
        self.sendDate = Date()
        self.roomId = roomId
        self.isChecked = false
        self.noticeType = .invite
    }
    
    init() {
        self.id = UUID()
        self.noticeId = UUID().uuidString
        self.senderUserId = "unknownUserId"
        self.sendUser = User()
        self.sendDate = Date()
        self.roomId = ""
        self.isChecked = false
        self.noticeType = .unknown
    }
}
