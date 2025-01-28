//
//  PlayerPositionRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/12/09.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class PlayerPositionRepository {
//    create
    
//    check
    
//    get
    
//    update
    static func randomInitialPosition() async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let horizontalCount = PlayerDataStore.shared.playingRoom.horizontalCount
        let verticalCount = PlayerDataStore.shared.playingRoom.verticalCount
        let initialX = Int.random(in: 0 ..< horizontalCount)
        let initialY = Int.random(in: 0 ..< verticalCount)
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["move": [["phase": 1, "x": initialX, "y": initialY]]])
        } catch {
            print(error)
        }
    }
    
    static func updateMyPosition(phase: Int, x: Int, y: Int) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        await updatePosition(phase: phase, userId: userId, x: x, y: y)
    }
    
    static func updatePosition(phase: Int, userId: String, x: Int, y: Int) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["move": FieldValue.arrayUnion([["phase": phase, "x": x, "y": y]]), "isDecided": true])
        } catch {
            print(error)
        }
    }
    
//    delete
    
//    observe
    
}
