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
    var proposerUserId: String
    var targetUserId: String
    var condition: dealCondition
    var proposePhase: Int
    var expiredPhase: Int
    
    enum dealCondition: String {
        case success, failure, fulfilled, proposing, proposed, unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case dealId, negotiationId, proposerUserId, targetUserId, condition, proposePhase, expiredPhase
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.dealId = try container.decode(UUID.self, forKey: .dealId)
        self.negotiationId = try container.decode(String.self, forKey: .negotiationId)
        self.proposerUserId = try container.decode(String.self, forKey: .proposerUserId)
        self.targetUserId = try container.decode(String.self, forKey: .targetUserId)
        let condition = try container.decode(String.self, forKey: .condition)
        self.condition = dealCondition(rawValue: condition) ?? .unknown
        self.proposePhase = try container.decode(Int.self, forKey: .proposePhase)
        self.expiredPhase = try container.decode(Int.self, forKey: .expiredPhase)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.dealId, forKey: .dealId)
        try container.encode(self.negotiationId, forKey: .negotiationId)
        try container.encode(self.proposerUserId, forKey: .proposerUserId)
        try container.encode(self.targetUserId, forKey: .targetUserId)
        try container.encode(self.targetUserId, forKey: .targetUserId)
        try container.encode(self.condition.rawValue, forKey: .condition)
        try container.encode(self.proposePhase, forKey: .proposePhase)
        try container.encode(self.expiredPhase, forKey: .expiredPhase)
    }
    
    init(dealId: UUID, negotiationId: String, proposerUserId: String, targetUserId: String, condition: dealCondition, proposePhase: Int, expiredPhase: Int) {
        self.id = UUID()
        self.dealId = dealId
        self.negotiationId = negotiationId
        self.proposerUserId = proposerUserId
        self.targetUserId = targetUserId
        self.condition = condition
        self.proposePhase = proposePhase
        self.expiredPhase = expiredPhase
    }
    
    init(negotiationId: String, proposerUserId: String, targetUserId: String, expiredPhase: Int) {
        self.id = UUID()
        self.dealId = UUID()
        self.negotiationId = negotiationId
        self.proposerUserId = proposerUserId
        self.targetUserId = targetUserId
        self.condition = .proposing
        self.proposePhase = PlayerDataStore.shared.playingRoom.phaseNow
        self.expiredPhase = expiredPhase
    }
    
    init() {
        self.dealId = UUID()
        self.negotiationId = "unknownNegotiationId"
        self.proposerUserId = "unknownProposerUserId"
        self.targetUserId = "unknownTargetUserId"
        self.condition = .unknown
        self.proposePhase = 0
        self.expiredPhase = 0
    }
}
