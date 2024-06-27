//
//  PlayTagRoom.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import Foundation

struct PlayTagRoom: Codable, Hashable, Identifiable {
    var id = UUID()
    var roomId: UUID
    var playTagName: String
    var phaseNow: Int
    var phaseMax: Int
    var chaserNumber: Int
    var fugitiveNumber: Int
    var horizontalCount: Int
    var verticalCount: Int
    var isPublic: Bool
    var isCanJoinAfter: Bool
    var isNegotiate: Bool
    var isCanDoQuest: Bool
    var isCanUseItem: Bool
    
    init(roomId: UUID, playTagName: String, phaseNow: Int, phaseMax: Int, chaserNumber: Int, fugitiveNumber: Int, horizontalCount: Int, verticalCount: Int, isPublic: Bool, isCanJoinAfter: Bool, isNegotiate: Bool, isCanDoQuest: Bool, isCanUseItem: Bool) {
        self.roomId = roomId
        self.playTagName = playTagName
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
    
    init() {
        self.roomId = UUID()
        self.playTagName = "unknownPlayTag"
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
