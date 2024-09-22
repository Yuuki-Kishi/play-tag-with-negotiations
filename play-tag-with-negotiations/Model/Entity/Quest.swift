//
//  Quest.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/14.
//

import Foundation

struct Quest: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Quest, rhs: Quest) -> Bool {
        return lhs.questId == rhs.questId
    }
    
    var id = UUID()
    var questId: UUID
    var missionId: String
    var contractorUserId: String
    var condition: qusetCondition
    var acceptPhase: Int
    var deadlinePhase: Int
    
    enum qusetCondition: String {
        case completed, executing, failured, unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case questId, missionId, contractorUserId, condition, acceptPhase, deadlinePhase
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.questId = try container.decode(UUID.self, forKey: .questId)
        self.missionId = try container.decode(String.self, forKey: .missionId)
        self.contractorUserId = try container.decode(String.self, forKey: .contractorUserId)
        let condition = try container.decode(String.self, forKey: .condition)
        self.condition = qusetCondition(rawValue: condition) ?? .unknown
        self.acceptPhase = try container.decode(Int.self, forKey: .acceptPhase)
        self.deadlinePhase = try container.decode(Int.self, forKey: .deadlinePhase)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.questId, forKey: .questId)
        try container.encode(self.missionId, forKey: .missionId)
        try container.encode(self.contractorUserId, forKey: .contractorUserId)
        try container.encode(self.condition.rawValue, forKey: .condition)
        let formatter = ISO8601DateFormatter()
        try container.encode(acceptPhase, forKey: .acceptPhase)
        try container.encode(deadlinePhase, forKey: .deadlinePhase)
    }
    
    init(questId: UUID, missionId: String, contractorUserId: String, condition: qusetCondition, acceptPhase: Int, deadlinePhase: Int) {
        self.id = UUID()
        self.questId = questId
        self.missionId = missionId
        self.contractorUserId = contractorUserId
        self.condition = condition
        self.acceptPhase = acceptPhase
        self.deadlinePhase = deadlinePhase
    }
    
    init(missionId: String, contractorUserId: String, deadlinePhase: Int) {
        self.id = UUID()
        self.questId = UUID()
        self.missionId = missionId
        self.contractorUserId = contractorUserId
        self.condition = .executing
        self.acceptPhase = PlayerDataStore.shared.playingRoom.phaseNow
        self.deadlinePhase = deadlinePhase
    }
}
