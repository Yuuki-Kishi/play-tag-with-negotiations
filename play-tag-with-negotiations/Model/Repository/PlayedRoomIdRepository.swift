//
//  File.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/28.
//

import Foundation
import FirebaseFirestore

class PlayedRoomIdRepository {
    //update
    static func addPlayedRoomIds(roomId: String) async {
        guard var myUser = UserDataStore.shared.signInUser else { return }
        let playedRoomId = PlayedRoomId(roomId: roomId)
        let encoded = try! JSONEncoder().encode(playedRoomId)
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            if myUser.playedRoomIds.count > 100 {
                myUser.playedRoomIds.sort { $0.playedDate > $1.playedDate }
                guard let deletePlayedRoomId = myUser.playedRoomIds.first else { return }
                await removePlayedRoomIds(roomId: deletePlayedRoomId.roomId)
            }
            try await Firestore.firestore().collection("Users").document(myUser.userId).setData(["currentRoomId": roomId], merge: true)
            try await Firestore.firestore().collection("Users").document(myUser.userId).updateData(["playedRoomIds": FieldValue.arrayUnion([jsonObject])])
        } catch {
            print(error)
        }
    }
    
    //delete
    static func removePlayedRoomIds(roomId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        guard let playedRoomId = UserDataStore.shared.signInUser?.playedRoomIds.first(where: { $0.roomId == roomId }) else { return }
        let encoded = try! JSONEncoder().encode(playedRoomId)
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("Users").document(userId).updateData(["currentRoomId": FieldValue.delete(), "playedRoomIds": FieldValue.arrayRemove([jsonObject])])
        } catch {
            print(error)
        }
    }
    
    static func deletePlayedRoomIds() async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).updateData(["playedRoomIds": []])
        } catch {
            print(error)
        }
    }
}
