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
    var pertnerUser: User
    var proposalDate: Date
    var executionDate: Date
    var status: FriendShipStatus
    
    enum FriendShipStatus: String {
        case pending, accepted, rejected, unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case friendShipId, proposerUserId, consenterUserId, proposalDate, executionDate, status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.friendShipId = try container.decode(String.self, forKey: .friendShipId)
        self.proposerUserId = try container.decode(String.self, forKey: .proposerUserId)
        self.consenterUserId = try container.decode(String.self, forKey: .consenterUserId)
        self.pertnerUser = User()
        let formatter = ISO8601DateFormatter()
        let proposalDateString = try container.decode(String.self, forKey: .proposalDate)
        if let date = formatter.date(from: proposalDateString) {
            self.proposalDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .proposalDate, in: container, debugDescription: "Failed to decode editedTime.")
        }
        let executionDateString = try container.decode(String.self, forKey: .executionDate)
        if let date = formatter.date(from: executionDateString) {
            self.executionDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .executionDate, in: container, debugDescription: "Failed to decode editedTime.")
        }
        let type = try container.decode(String.self, forKey: .status)
        self.status = FriendShipStatus(rawValue: type) ?? .unknown
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.friendShipId, forKey: .friendShipId)
        try container.encode(self.proposerUserId, forKey: .proposerUserId)
        try container.encode(self.consenterUserId, forKey: .consenterUserId)
        let formatter = ISO8601DateFormatter()
        let proposalDateString = formatter.string(from: proposalDate)
        try container.encode(proposalDateString, forKey: .proposalDate)
        let executionDateString = formatter.string(from: executionDate)
        try container.encode(executionDateString, forKey: .executionDate)
        try container.encode(self.status.rawValue, forKey: .status)
    }
    
    init(friendShipId: String, proposerUserId: String, consenterUserId: String, pertnerUser: User, proposalDate: Date, executionDate: Date, status: FriendShipStatus) {
        self.id = UUID()
        self.friendShipId = friendShipId
        self.proposerUserId = proposerUserId
        self.consenterUserId = consenterUserId
        self.pertnerUser = pertnerUser
        self.proposalDate = proposalDate
        self.executionDate = executionDate
        self.status = status
    }
    
    init(proposerUserId: String, consenterUserId: String) {
        self.id = UUID()
        self.friendShipId = [proposerUserId, consenterUserId].sorted().joined(separator: "_")
        self.proposerUserId = proposerUserId
        self.consenterUserId = consenterUserId
        self.pertnerUser = User()
        self.proposalDate = Date()
        self.executionDate = Date()
        self.status = .pending
    }
    
    init() {
        self.id = UUID()
        self.friendShipId = UUID().uuidString
        self.proposerUserId = "unknownUserId"
        self.consenterUserId = "unknownUserId"
        self.pertnerUser = User()
        self.proposalDate = Date()
        self.executionDate = Date()
        self.status = .unknown
    }
}
