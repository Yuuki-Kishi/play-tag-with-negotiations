//
//  Update.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/19.
//

import Foundation
import FirebaseFirestore

class UpdateToFirestore {
    static func updateUserName(newName: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).setData(["userName": newName], merge: true)
        } catch {
            print(error)
        }
    }
    
    static func updatePronoun(newPronoun: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).setData(["pronoun": newPronoun], merge: true)
        } catch {
            print(error)
        }
    }
    
    static func updateIconUrl(iconUrl: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).setData(["iconUrl": iconUrl], merge: true)
        } catch {
            print(error)
        }
    }
    
    static func playerUpToHost(roomId: String, nextHostUserId: String) async {
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(nextHostUserId).updateData(["isHost": true])
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["hostUserId": nextHostUserId])
        } catch {
            print(error)
        }
    }
    
    static func becomeFriend(friendUserId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let formatter = ISO8601DateFormatter()
        let time = formatter.string(from: Date())
        do {
            try await Firestore.firestore().collection("Users").document(userId).collection("Friends").document(friendUserId).updateData(["isFriend": true, "editedTime": time])
        } catch {
            print(error)
        }
    }
}
