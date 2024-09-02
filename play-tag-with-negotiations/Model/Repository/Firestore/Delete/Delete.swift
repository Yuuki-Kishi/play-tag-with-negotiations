//
//  Delete.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/04.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class Delete {
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
        guard let nextHostUserId = PlayerDataStore.shared.playerArray.guests.randomElement() else { return }
        await Update.playerUpToHost(roomId: roomId, nextHostUserId: nextHostUserId.playerUserId)
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
            try await Firestore.firestore().collection("Users").document(friendUserId).collection("Friends").document(userId).delete()
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
