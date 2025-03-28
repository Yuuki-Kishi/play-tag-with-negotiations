//
//  PlayedRoom.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/28.
//

import Foundation

struct PlayedRoom: Hashable, Identifiable, Equatable {
    static func == (lhs: PlayedRoom, rhs: PlayedRoom) -> Bool {
        return lhs.roomId == rhs.roomId
    }
    var id = UUID()
    var roomId: String
    var hostUserId: String
    var playTagName: String
    var creationDate: Date
    var isPlaying: Bool
    var isFinished: Bool
    var isPublic: Bool
    var isCanJoinAfter: Bool
    var isDeal: Bool
    var playerNumber: Int
    var phaseMax: Int
    var phaseNow: Int
    var horizontalCount: Int
    var verticalCount: Int
    var chaserNumber: Int
    var fugitiveNumber: Int
    var players: [Player]
    
    enum displayItemType: CaseIterable {
        case roomId, hostUserId, playTagName, creationDate, isPublic, isCanJoinAfter, isDeal, phaseMax, horizontalCount, verticalCount, chaserNumber, fugitiveNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case roomId, hostUserId, playTagName, creationDate, isPlaying, isFinished, isPublic, isCanJoinAfter, isDeal, playerNumber, phaseMax, phaseNow, horizontalCount, verticalCount, chaserNumber, fugitiveNumber
    }
    
    init(roomId: String, hostUserId: String, playTagName: String, creationDate: Date, isPlaying: Bool, isFinished: Bool, isPublic: Bool, isCanJoinAfter: Bool, isDeal: Bool, playerNumber: Int, phaseMax: Int, phaseNow: Int, horizontalCount: Int, verticalCount: Int, chaserNumber: Int, fugitiveNumber: Int, players: [Player]) {
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
        self.players = players
    }
    
    init(playTagRoom: PlayTagRoom, players: [Player]) {
        self.roomId = playTagRoom.roomId
        self.hostUserId = playTagRoom.hostUserId
        self.playTagName = playTagRoom.playTagName
        self.creationDate = playTagRoom.creationDate
        self.isPlaying = playTagRoom.isPlaying
        self.isFinished = playTagRoom.isFinished
        self.isPublic = playTagRoom.isPublic
        self.isCanJoinAfter = playTagRoom.isCanJoinAfter
        self.isDeal = playTagRoom.isDeal
        self.playerNumber = playTagRoom.playerNumber
        self.phaseMax = playTagRoom.phaseMax
        self.phaseNow = playTagRoom.phaseNow
        self.horizontalCount = playTagRoom.horizontalCount
        self.verticalCount = playTagRoom.verticalCount
        self.chaserNumber = playTagRoom.chaserNumber
        self.fugitiveNumber = playTagRoom.fugitiveNumber
        self.players = players
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
        self.horizontalCount = 5
        self.verticalCount = 5
        self.chaserNumber = 1
        self.fugitiveNumber = 4
        self.players = []
    }
}
