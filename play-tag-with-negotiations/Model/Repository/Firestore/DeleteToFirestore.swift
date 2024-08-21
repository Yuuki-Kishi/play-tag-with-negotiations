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
            try await Firestore.firestore().collection("Users").document(userId).updateData(["beingRoomId": FieldValue.delete()])
        } catch {
            print(error)
        }
    }
    
    static func hostExitRoom(roomId: String) async {
        guard let nextHostUserId = PlayerDataStore.shared.guestPlayerArray.randomElement() else { return }
        await UpdateToFirestore.playerUpToHost(roomId: roomId, nextHostUserId: nextHostUserId.userId)
        await exitRoom(roomId: roomId)
    }
    
    static func deleteRoom(roomId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).delete()
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).delete()
            try await Firestore.firestore().collection("Users").document(userId).updateData(["beingRoomId": FieldValue.delete()])
        } catch {
            print(error)
        }
    }
    
    static func deleteFriend(friendUserId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).collection("Friends").document(friendUserId).delete()
        } catch {
            print(error)
        }
    }
    
    static func endGame() async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).updateData(["beingRoomId": FieldValue.delete()])
        } catch {
            print(error)
        }
    }
}
