//
//  UpdateDocument.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/18.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class Create {
    static func createUser(userId: String) {
        Task {
            if await Read.isWriteUserName() {
                try await Firestore.firestore().collection("Users").document(userId).setData(["userName": "未設定"], merge: true)
            }
            if await Read.isWritePronoun() {
                try await Firestore.firestore().collection("Users").document(userId).setData(["pronoun": "未設定"], merge: true)
            }
        }
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
        
        if isPublic {
            Firestore.firestore().collection("PlayTagRooms").document("roomCollections").collection("publicRooms").document(roomId).collection("roomDatas").document("roomInfo").setData(["playTagName": playTagName, "phaseNow": phaseNow, "phaseMax": phaseMax, "chaserNumber": chaserNumber, "fugitiveNumber": fugitiveNumber, "isPublic": isPublic, "isCanJoinAfter": isCanJoinAfter, "isNegotiate": isNegotiate, "isCanDoQuest": isCanDoQuest, "isCanUseItem": isCanUseItem], merge: false)
        } else {
            Firestore.firestore().collection("PlayTagRooms").document("roomCollections").collection("privateRooms").document(roomId).collection("roomDatas").document("roomInfo").setData(["playTagName": playTagName, "phaseNow": phaseNow, "phaseMax": phaseMax, "chaserNumber": chaserNumber, "fugitiveNumber": fugitiveNumber, "isPublic": isPublic, "isCanJoinAfter": isCanJoinAfter, "isNegotiate": isNegotiate, "isCanDoQuest": isCanDoQuest, "isCanUseItem": isCanUseItem], merge: false)
        }
    }
}
