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
    var proposeDate: Date
    
    enum CodingKeys: String, CodingKey {
        case dealId, negotiationId, proposerUserId, targetUserId, proposeDate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
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
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: self.proposeDate)
        try container.encode(dateString, forKey: .proposeDate)
    }
    
    init(dealId: UUID, negotiationId: String, negotiation: Negotiation, proposerUserId: String, proposer: User, targetUserId: String, target: User, proposeDate: Date) {
        self.dealId = dealId
        self.negotiationId = negotiationId
        self.negotiation = negotiation
        self.proposerUserId = proposerUserId
        self.proposer = proposer
        self.targetUserId = targetUserId
        self.target = target
        self.proposeDate = proposeDate
    }
    
    init() {
        self.dealId = UUID()
        self.negotiationId = "unknownNegotiationId"
        self.negotiation = Negotiation()
        self.proposerUserId = "unknownProposerUserId"
        self.proposer = User()
        self.targetUserId = "unknownTargetUserId"
        self.target = User()
        self.proposeDate = Date()
    }
}
