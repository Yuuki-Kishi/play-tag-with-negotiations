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
    var roomId: String
    var hostUserId: String
    var playTagName: String
    var creationDate: Date
    var isPlaying: Bool
    var isFinished: Bool
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
    var isDeal: Bool
    var playerNumber: Int
    var phaseMax: Int
    var phaseNow: Int
    var horizontalCount: Int
    var verticalCount: Int
    var chaserNumber: Int
    var fugitiveNumber: Int
    
    enum displayItemType: CaseIterable {
        case roomId, hostUserId, playTagName, creationDate, isPublic, isCanJoinAfter, isDeal, phaseMax, horizontalCount, verticalCount, chaserNumber, fugitiveNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case roomId, hostUserId, playTagName, creationDate, isPlaying, isFinished, isPublic, isCanJoinAfter, isDeal, playerNumber, phaseMax, phaseNow, horizontalCount, verticalCount, chaserNumber, fugitiveNumber
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.roomId = try container.decode(String.self, forKey: .roomId)
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
        self.isFinished = try container.decode(Bool.self, forKey: .isFinished)
        self.isPublic = try container.decode(Bool.self, forKey: .isPublic)
        self.isCanJoinAfter = try container.decode(Bool.self, forKey: .isCanJoinAfter)
        self.isDeal = try container.decode(Bool.self, forKey: .isDeal)
        self.playerNumber = try container.decode(Int.self, forKey: .playerNumber)
        self.phaseMax = try container.decode(Int.self, forKey: .phaseMax)
        self.phaseNow = try container.decode(Int.self, forKey: .phaseNow)
        self.horizontalCount = try container.decode(Int.self, forKey: .horizontalCount)
        self.verticalCount = try container.decode(Int.self, forKey: .verticalCount)
        self.chaserNumber = try container.decode(Int.self, forKey: .chaserNumber)
        self.fugitiveNumber = try container.decode(Int.self, forKey: .fugitiveNumber)
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
        try container.encode(isFinished, forKey: .isFinished)
        try container.encode(isPublic, forKey: .isPublic)
        try container.encode(isCanJoinAfter, forKey: .isCanJoinAfter)
        try container.encode(isDeal, forKey: .isDeal)
        try container.encode(playerNumber, forKey: .playerNumber)
        try container.encode(phaseMax, forKey: .phaseMax)
        try container.encode(phaseNow, forKey: .phaseNow)
        try container.encode(horizontalCount, forKey: .horizontalCount)
        try container.encode(verticalCount, forKey: .verticalCount)
        try container.encode(chaserNumber, forKey: .chaserNumber)
        try container.encode(fugitiveNumber, forKey: .fugitiveNumber)
    }
    
    init(roomId: String, hostUserId: String, playTagName: String, creationDate: Date, isPlaying: Bool, isFinished: Bool, isPublic: Bool, isCanJoinAfter: Bool, isDeal: Bool, playerNumber: Int, phaseMax: Int, phaseNow: Int, horizontalCount: Int, verticalCount: Int, chaserNumber: Int, fugitiveNumber: Int) {
        self.roomId = roomId
        self.hostUserId = hostUserId
        self.playTagName = playTagName
        self.creationDate = creationDate
        self.isPlaying = isPlaying
        self.isFinished = isFinished
        self.isPublic = isPublic
        self.isCanJoinAfter = isCanJoinAfter
        self.isDeal = isDeal
        self.playerNumber = playerNumber
        self.phaseMax = phaseMax
        self.phaseNow = phaseNow
        self.horizontalCount = horizontalCount
        self.verticalCount = verticalCount
        self.chaserNumber = chaserNumber
        self.fugitiveNumber = fugitiveNumber
    }
    
    init(playTagName: String) {
        self.roomId = UUID().uuidString
        self.hostUserId = UserDataStore.shared.signInUser?.userId ?? "unknownHostUserId"
        self.playTagName = playTagName
        self.creationDate = Date()
        self.isPlaying = false
        self.isFinished = false
        self.isPublic = false
        self.isCanJoinAfter = false
        self.isDeal = true
        self.playerNumber = 0
        self.phaseMax = 10
        self.phaseNow = 0
        self.horizontalCount = 5
        self.verticalCount = 5
        self.chaserNumber = 1
        self.fugitiveNumber = 4
    }
    
    init() {
        self.roomId = UUID().uuidString
        self.hostUserId = "unknownHostUserId"
        self.playTagName = "unknownPlayTag"
        self.creationDate = Date()
        self.isPlaying = false
        self.isFinished = false
        self.isPublic = false
        self.isCanJoinAfter = false
        self.isDeal = true
        self.playerNumber = 0
        self.phaseMax = 10
        self.phaseNow = 0
        self.horizontalCount = 0
        self.verticalCount = 0
        self.chaserNumber = 0
        self.fugitiveNumber = 0
    }
}
