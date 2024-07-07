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
    static func createUser(user: User) async {
        let encoded = try! JSONEncoder().encode(user)
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("Users").document(user.userId).setData(jsonObject)
        } catch {
            print(error)
        }
    }
    
    static func createPlayTagRoom(playTagRoom: PlayTagRoom) async {
        let encoded = try! JSONEncoder().encode(playTagRoom)
        let roomId = playTagRoom.roomId.uuidString
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).setData(jsonObject)
        } catch {
            print(error)
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
