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
    var dealId: String
    var negotiationId: String
    var proposerUserId: String
    var clientUserId: String
    var proposedPhase: Int
    var expiredPhase: Int
    var consideration: Int
    var condition: dealCondition
    
    enum dealCondition: String {
        case success, proposing, proposed, fulfilled, failure, unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case dealId, negotiationId, proposerUserId, clientUserId, proposedPhase, expiredPhase, consideration, condition
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.dealId = try container.decode(String.self, forKey: .dealId)
        self.negotiationId = try container.decode(String.self, forKey: .negotiationId)
        self.proposerUserId = try container.decode(String.self, forKey: .proposerUserId)
        self.clientUserId = try container.decode(String.self, forKey: .clientUserId)
        self.proposedPhase = try container.decode(Int.self, forKey: .proposedPhase)
        self.expiredPhase = try container.decode(Int.self, forKey: .expiredPhase)
        self.consideration = try container.decode(Int.self, forKey: .consideration)
        let condition = try container.decode(String.self, forKey: .condition)
        self.condition = dealCondition(rawValue: condition) ?? .unknown
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.dealId, forKey: .dealId)
        try container.encode(self.negotiationId, forKey: .negotiationId)
        try container.encode(self.proposerUserId, forKey: .proposerUserId)
        try container.encode(self.clientUserId, forKey: .clientUserId)
        try container.encode(self.proposedPhase, forKey: .proposedPhase)
        try container.encode(self.expiredPhase, forKey: .expiredPhase)
        try container.encode(self.consideration, forKey: .consideration)
        try container.encode(self.condition.rawValue, forKey: .condition)
    }
    
    init(dealId: String, negotiationId: String, proposerUserId: String, clientUserId: String, proposedPhase: Int, expiredPhase: Int, consideration: Int, condition: dealCondition) {
        self.id = UUID()
        self.dealId = dealId
        self.negotiationId = negotiationId
        self.proposerUserId = proposerUserId
        self.clientUserId = clientUserId
        self.proposedPhase = proposedPhase
        self.expiredPhase = expiredPhase
        self.consideration = consideration
        self.condition = condition
    }
    
    init(negotiationId: String, proposerUserId: String, clientUserId: String, period: Int, consideration: Int) {
        self.id = UUID()
        self.dealId = UUID().uuidString
        self.negotiationId = negotiationId
        self.proposerUserId = proposerUserId
        self.clientUserId = clientUserId
        self.proposedPhase = PlayerDataStore.shared.playingRoom.phaseNow
        self.expiredPhase = PlayerDataStore.shared.playingRoom.phaseNow + period
        self.consideration = consideration
        self.condition = .proposed
    }
    
    init() {
        self.dealId = UUID().uuidString
        self.negotiationId = "unknownNegotiationId"
        self.proposerUserId = "unknownProposerUserId"
        self.clientUserId = "unknownTargetUserId"
        self.proposedPhase = 0
        self.expiredPhase = 0
        self.consideration = 0
        self.condition = .unknown
    }
}
