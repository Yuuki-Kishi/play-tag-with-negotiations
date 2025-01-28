//
//  Friend.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/11.
//

import Foundation

struct FriendShip: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: FriendShip, rhs: FriendShip) -> Bool {
        return lhs.friendShipId == rhs.friendShipId
    }
    var id = UUID()
    var friendShipId: String
    var proposerUserId: String
    var consenterUserId: String
    var proposalDate: Date
    var excutionDate: Date
    var isFriend: Bool
    
    enum CodingKeys: String, CodingKey {
        case friendShipId, proposerUserId, consenterUserId, proposalDate, excutionDate, isFriend
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.friendShipId = try container.decode(String.self, forKey: .friendShipId)
        self.proposerUserId = try container.decode(String.self, forKey: .proposerUserId)
        self.consenterUserId = try container.decode(String.self, forKey: .consenterUserId)
        let formatter = ISO8601DateFormatter()
        let proposalDateString = try container.decode(String.self, forKey: .proposalDate)
        if let date = formatter.date(from: proposalDateString) {
            self.proposalDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .proposalDate, in: container, debugDescription: "Failed to decode editedTime.")
        }
        let excutionDateString = try container.decode(String.self, forKey: .excutionDate)
        if let date = formatter.date(from: excutionDateString) {
            self.excutionDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .excutionDate, in: container, debugDescription: "Failed to decode editedTime.")
        }
        self.isFriend = try container.decode(Bool.self, forKey: .isFriend)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.friendShipId, forKey: .friendShipId)
        try container.encode(self.proposerUserId, forKey: .proposerUserId)
        try container.encode(self.consenterUserId, forKey: .consenterUserId)
        let formatter = ISO8601DateFormatter()
        let proposalDateString = formatter.string(from: proposalDate)
        try container.encode(proposalDateString, forKey: .proposalDate)
        let excutionDateString = formatter.string(from: excutionDate)
        try container.encode(excutionDateString, forKey: .excutionDate)
        try container.encode(self.isFriend, forKey: .isFriend)
    }
    
    init(friendShipId: String, proposerUserId: String, consenterUserId: String, proposalDate: Date, excutionDate: Date, isFriend: Bool) {
        self.id = UUID()
        self.friendShipId = friendShipId
        self.proposerUserId = proposerUserId
        self.consenterUserId = consenterUserId
        self.proposalDate = proposalDate
        self.excutionDate = excutionDate
        self.isFriend = isFriend
    }
    
    init(proposerUserId: String, consentUserId: String) {
        self.id = UUID()
        self.friendShipId = UUID().uuidString
        self.proposerUserId = proposerUserId
        self.consenterUserId = consentUserId
        self.proposalDate = Date()
        self.excutionDate = Date()
        self.isFriend = false
    }
    
    init() {
        self.id = UUID()
        self.friendShipId = UUID().uuidString
        self.proposerUserId = "unknownUserId"
        self.consenterUserId = "unknownUserId"
        self.proposalDate = Date()
        self.excutionDate = Date()
        self.isFriend = false
    }
}
