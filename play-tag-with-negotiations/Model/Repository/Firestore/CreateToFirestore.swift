//
//  UpdateDocument.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/18.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class CreateToFirestore {
    static func createUser(userId: String) {
        Task {
            if await ReadToFirestore.isWriteUserName() {
                try await Firestore.firestore().collection("Users").document(userId).setData(["userName": "未設定"], merge: true)
            }
            if await ReadToFirestore.isWritePronoun() {
                try await Firestore.firestore().collection("Users").document(userId).setData(["pronoun": "未設定"], merge: true)
            }
        }
    }
    
    static func createPlayTagRoom(playTagRoom: PlayTagRoom) {
        let roomId = playTagRoom.roomId.uuidString
        let hostUserId = playTagRoom.hostUserId
        let playTagName = playTagRoom.playTagName
        let creationDate = playTagRoom.creationDate
        let phaseNow = playTagRoom.phaseNow
        let phaseMax = playTagRoom.phaseMax
        let chaserNumber = playTagRoom.chaserNumber
        let fugitiveNumber = playTagRoom.fugitiveNumber
        let horizontalCount = playTagRoom.horizontalCount
        let verticalCount = playTagRoom.verticalCount
        let isPublic = playTagRoom.isPublic
        let isCanJoinAfter = playTagRoom.isCanJoinAfter
        let isNegotiate = playTagRoom.isNegotiate
        let isCanDoQuest = playTagRoom.isCanDoQuest
        let isCanUseItem = playTagRoom.isCanUseItem
        Task {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).setData(["roomId": roomId, "hostUserId": hostUserId, "playTagName": playTagName, "creationDate": creationDate, "phaseNow": phaseNow, "phaseMax": phaseMax, "chaserNumber": chaserNumber, "fugitiveNumber": fugitiveNumber, "horizontalCount": horizontalCount, "verticalCount": verticalCount, "isPublic": isPublic, "isCanJoinAfter": isCanJoinAfter, "isNegotiate": isNegotiate, "isCanDoQuest": isCanDoQuest, "isCanUseItem": isCanUseItem], merge: false)
            await enterRoom(roomId: roomId, isHost: true)
        }
    }
    
    static func enterRoom(roomId: String, isHost: Bool) async {
        if await !ReadToFirestore.isBeingRoom(roomId: roomId) {
            guard let userId = UserDataStore.shared.signInUser?.userId else { return }
            do {
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).setData(["userId": userId, "isHost": isHost, "point": 0, "enteredTime": Date(), "isDecided": false])
                try await Firestore.firestore().collection("Users").document(userId).setData(["beingRoom": roomId], merge: true)
            } catch {
                print(error)
            }
        }
    }
}
