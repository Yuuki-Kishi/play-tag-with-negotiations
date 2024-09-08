//
//  Deat.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/30.
//

import Foundation

struct Deal: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Deal, rhs: Deal) -> Bool {
        return lhs.dealId == rhs.dealId
    }
    
    var id = UUID()
    var dealId: UUID
    var negotiationId: String
    var negotiation: Negotiation
    var proposerUserId: String
    var proposer: User
    var targetUserId: String
    var target: User
    var condition: dealCondition
    var proposeDate: Date
    
    enum dealCondition: String {
        case success, failure, fulfilled, proposing, unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case dealId, negotiationId, proposerUserId, targetUserId, condition, proposeDate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        let dealIdString = try container.decode(String.self, forKey: .dealId)
        if let dealId = UUID(uuidString: dealIdString) {
            self.dealId = dealId
        } else {
            throw DecodingError.dataCorruptedError(forKey: .dealId, in: container, debugDescription: "Failed to decode dealId")
        }
        self.negotiationId = try container.decode(String.self, forKey: .negotiationId)
        self.negotiation = Negotiation()
        self.proposerUserId = try container.decode(String.self, forKey: .proposerUserId)
        self.proposer = User()
        self.targetUserId = try container.decode(String.self, forKey: .targetUserId)
        self.target = User()
        let condition = try container.decode(String.self, forKey: .condition)
        self.condition = dealCondition(rawValue: condition) ?? .unknown
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .proposeDate)
        if let date = formatter.date(from: dateString) {
            self.proposeDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .proposeDate, in: container, debugDescription: "Failed to decode proposeDate.")
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.dealId, forKey: .dealId)
        try container.encode(self.negotiationId, forKey: .negotiationId)
        try container.encode(self.proposerUserId, forKey: .proposerUserId)
        try container.encode(self.targetUserId, forKey: .targetUserId)
        try container.encode(self.targetUserId, forKey: .targetUserId)
        try container.encode(self.condition.rawValue, forKey: .condition)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: self.proposeDate)
        try container.encode(dateString, forKey: .proposeDate)
    }
    
    init(dealId: UUID, negotiationId: String, negotiation: Negotiation, proposerUserId: String, proposer: User, targetUserId: String, target: User, condition: dealCondition, proposeDate: Date) {
        self.id = UUID()
        self.dealId = dealId
        self.negotiationId = negotiationId
        self.negotiation = negotiation
        self.proposerUserId = proposerUserId
        self.proposer = proposer
        self.targetUserId = targetUserId
        self.target = target
        self.condition = condition
        self.proposeDate = proposeDate
    }
    
    init(negotiation: Negotiation, proposer: User, target: User) {
        self.id = UUID()
        self.dealId = UUID()
        self.negotiationId = negotiation.negotiationId.uuidString
        self.negotiation = negotiation
        self.proposerUserId = proposer.userId
        self.proposer = proposer
        self.targetUserId = target.userId
        self.target = target
        self.condition = .proposing
        self.proposeDate = Date()
    }
    
    init() {
        self.dealId = UUID()
        self.negotiationId = "unknownNegotiationId"
        self.negotiation = Negotiation()
        self.proposerUserId = "unknownProposerUserId"
        self.proposer = User()
        self.targetUserId = "unknownTargetUserId"
        self.target = User()
        self.condition = .unknown
        self.proposeDate = Date()
    }
}
