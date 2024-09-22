//
//  Mission.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/13.
//

import Foundation

struct Mission: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Mission, rhs: Mission) -> Bool {
        return lhs.missionId == rhs.missionId
    }
    
    var id = UUID()
    var missionId: UUID
    var missionName: String
    var displayName: String
    var reward: Int
    var timeLimit: Int
    var imageName: String
    var version: Double
    
    enum CodingKeys: String, CodingKey {
        case missionId, missionName, displayName, reward, imageName, timeLimit, version
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.missionId = try container.decode(UUID.self, forKey: .missionId)
        self.missionName = try container.decode(String.self, forKey: .missionName)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.reward = try container.decode(Int.self, forKey: .reward)
        self.timeLimit = try container.decode(Int.self, forKey: .timeLimit)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.version = try container.decode(Double.self, forKey: .version)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.missionId, forKey: .missionId)
        try container.encode(self.missionName, forKey: .missionName)
        try container.encode(self.displayName, forKey: .displayName)
        try container.encode(self.reward, forKey: .reward)
        try container.encode(self.timeLimit, forKey: .timeLimit)
        try container.encode(self.imageName, forKey: .imageName)
        try container.encode(self.version, forKey: .version)
    }
    
    init(missionId: UUID, missionName: String, displayName: String, reward: Int, imageName: String, timeLimit: Int, version: Double) {
        self.id = UUID()
        self.missionId = missionId
        self.missionName = missionName
        self.displayName = displayName
        self.reward = reward
        self.timeLimit = timeLimit
        self.imageName = imageName
        self.version = version
    }
    
    init() {
        self.id = UUID()
        self.missionId = UUID()
        self.missionName = "unknownMiision"
        self.displayName = "unknownMiision"
        self.reward = 0
        self.timeLimit = 0
        self.imageName = "unknownImage"
        self.version = 1.0
    }
}
