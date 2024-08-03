//
//  PlayTagRoom.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import Foundation

struct PlayTagRoom: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: PlayTagRoom, rhs: PlayTagRoom) -> Bool {
        return lhs.roomId == rhs.roomId
    }
    
    var id = UUID()
    var roomId: UUID
    var hostUserId: String
    var playTagName: String
    var creationDate: Date
    var isPlaying: Bool
    var phaseNow: Int
    var phaseMax: Int
    var chaserNumber: Int
    var fugitiveNumber: Int
    var horizontalCount: Int
    var verticalCount: Int
    var isPublic: Bool {
        didSet {
            if isPublic == true && isCanJoinAfter == false {
                isCanJoinAfter = true
            }
        }
    }
    var isCanJoinAfter: Bool {
        didSet {
            if isCanJoinAfter == false && isPublic == true {
                isPublic = false
            }
        }
    }
    var isNegotiate: Bool
    var isCanDoQuest: Bool
    var isCanUseItem: Bool
    
    enum displayItemType: CaseIterable {
        case roomId, hostUserId, playTagName, creationDate, phaseNow, phaseMax, chaserNumber, fugitiveNumber, horizontalCount,
             verticalCount, isPublic, isCanJoinAfter, isNegotiate, isCanDoQuest, isCanUseItem
    }
    
    enum CodingKeys: String, CodingKey {
        case roomId, hostUserId, playTagName, creationDate, isPlaying, phaseNow, phaseMax, chaserNumber, fugitiveNumber, horizontalCount,
             verticalCount, isPublic, isCanJoinAfter, isNegotiate, isCanDoQuest, isCanUseItem
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.roomId = try container.decode(UUID.self, forKey: .roomId)
        self.hostUserId = try container.decode(String.self, forKey: .hostUserId)
        self.playTagName = try container.decode(String.self, forKey: .playTagName)
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .creationDate)
        if let date = formatter.date(from: dateString) {
            self.creationDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .creationDate, in: container, debugDescription: "Failed to decode creationDate.")
        }
        self.isPlaying = try container.decode(Bool.self, forKey: .isPlaying)
        self.phaseNow = try container.decode(Int.self, forKey: .phaseNow)
        self.phaseMax = try container.decode(Int.self, forKey: .phaseMax)
        self.chaserNumber = try container.decode(Int.self, forKey: .chaserNumber)
        self.fugitiveNumber = try container.decode(Int.self, forKey: .fugitiveNumber)
        self.horizontalCount = try container.decode(Int.self, forKey: .horizontalCount)
        self.verticalCount = try container.decode(Int.self, forKey: .verticalCount)
        self.isPublic = try container.decode(Bool.self, forKey: .isPublic)
        self.isCanJoinAfter = try container.decode(Bool.self, forKey: .isCanJoinAfter)
        self.isNegotiate = try container.decode(Bool.self, forKey: .isNegotiate)
        self.isCanDoQuest = try container.decode(Bool.self, forKey: .isCanDoQuest)
        self.isCanUseItem = try container.decode(Bool.self, forKey: .isCanUseItem)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(roomId, forKey: .roomId)
        try container.encode(hostUserId, forKey: .hostUserId)
        try container.encode(playTagName, forKey: .playTagName)
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: creationDate)
        try container.encode(dateString, forKey: .creationDate)
        try container.encode(isPlaying, forKey: .isPlaying)
        try container.encode(phaseNow, forKey: .phaseNow)
        try container.encode(phaseMax, forKey: .phaseMax)
        try container.encode(chaserNumber, forKey: .chaserNumber)
        try container.encode(fugitiveNumber, forKey: .fugitiveNumber)
        try container.encode(horizontalCount, forKey: .horizontalCount)
        try container.encode(verticalCount, forKey: .verticalCount)
        try container.encode(isPublic, forKey: .isPublic)
        try container.encode(isCanJoinAfter, forKey: .isCanJoinAfter)
        try container.encode(isNegotiate, forKey: .isNegotiate)
        try container.encode(isCanDoQuest, forKey: .isCanDoQuest)
        try container.encode(isCanUseItem, forKey: .isCanUseItem)
    }
    
    init(roomId: UUID, hostUserId: String, playTagName: String, creationDate: Date, isPlaying: Bool, phaseNow: Int, phaseMax: Int, chaserNumber: Int, fugitiveNumber: Int, horizontalCount: Int, verticalCount: Int, isPublic: Bool, isCanJoinAfter: Bool, isNegotiate: Bool, isCanDoQuest: Bool, isCanUseItem: Bool) {
        self.roomId = roomId
        self.hostUserId = hostUserId
        self.playTagName = playTagName
        self.creationDate = creationDate
        self.isPlaying = isPlaying
        self.phaseNow = phaseNow
        self.phaseMax = phaseMax
        self.chaserNumber = chaserNumber
        self.fugitiveNumber = fugitiveNumber
        self.horizontalCount = horizontalCount
        self.verticalCount = verticalCount
        self.isPublic = isPublic
        self.isCanJoinAfter = isCanJoinAfter
        self.isNegotiate = isNegotiate
        self.isCanDoQuest = isCanDoQuest
        self.isCanUseItem = isCanUseItem
    }
    
    init(playTagName: String) {
        self.roomId = UUID()
        self.hostUserId = UserDataStore.shared.signInUser?.userId ?? "unknownHostUserId"
        self.playTagName = playTagName
        self.creationDate = Date()
        self.isPlaying = false
        self.phaseNow = 0
        self.phaseMax = 10
        self.chaserNumber = 1
        self.fugitiveNumber = 3
        self.horizontalCount = 5
        self.verticalCount = 5
        self.isPublic = false
        self.isCanJoinAfter = false
        self.isNegotiate = true
        self.isCanDoQuest = true
        self.isCanUseItem = true
    }
    
    init() {
        self.roomId = UUID()
        self.hostUserId = "unknownHostUserId"
        self.playTagName = "unknownPlayTag"
        self.creationDate = Date()
        self.isPlaying = false
        self.phaseNow = 0
        self.phaseMax = 0
        self.chaserNumber = 0
        self.fugitiveNumber = 0
        self.horizontalCount = 0
        self.verticalCount = 0
        self.isPublic = false
        self.isCanJoinAfter = false
        self.isNegotiate = false
        self.isCanDoQuest = false
        self.isCanUseItem = false
    }
}
