//
//  Delete.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/04.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class DeleteToFirestore {
    static func exitRoom(roomId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).delete()
        } catch {
            print(error)
        }
    }
    
    static func hostExitRoom(roomId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        guard let nextHostUserId = PlayerDataStore.shared.playerArray.filter({ $0.userId != userId }).randomElement()?.userId else { return }
        await UpdateToFirestore.playerUpToHost(roomId: roomId, nextHostUserId: nextHostUserId)
        await exitRoom(roomId: roomId)
    }
    
    static func deleteRoom(roomId: String) async {
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).delete()
        } catch {
            print(error)
        }
    }
}
