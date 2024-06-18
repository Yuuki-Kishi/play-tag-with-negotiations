//
//  UpdateDocument.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/18.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class UpdateDocument {
    
    static func createUser(userId: String) {
        Firestore.firestore().collection("Users").document(userId).setData(["userName": "未設定", "onePhrase": "未設定"], merge: false)
    }
    
    static func createPlayTagRoom(playTagRoom: PlayTagRoom) {
        let roomId = playTagRoom.roomId.uuidString
        let playTagName = playTagRoom.playTagName
        let phaseNow = playTagRoom.phaseNow
        let phaseMax = playTagRoom.phaseMax
        let chaserNumber = playTagRoom.chaserNumber
        let fugitiveNumber = playTagRoom.fugitiveNumber
        let isPublic = playTagRoom.isPublic
        let isCanJoinAfter = playTagRoom.isCanJoinAfter
        let isNegotiate = playTagRoom.isNegotiate
        let isCanDoQuest = playTagRoom.isCanDoQuest
        let isCanUseItem = playTagRoom.isCanUseItem
        
        Firestore.firestore().collection("PlayTagRooms").document(roomId).setData(["playTagName": playTagName, "phaseNow": phaseNow, "phaseMax": phaseMax, "chaserNumber": chaserNumber, "fugitiveNumber": fugitiveNumber, "isPublic": isPublic, "isCanJoinAfter": isCanJoinAfter, "isNegotiate": isNegotiate, "isCanDoQuest": isCanDoQuest, "isCanUseItem": isCanUseItem], merge: true)
    }
}
