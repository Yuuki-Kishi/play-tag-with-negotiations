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
            await enterRoom(roomId: roomId, isHost: true)
        } catch {
            print(error)
        }
    }
    
    static func enterRoom(roomId: String, isHost: Bool) async {
        if await !ReadToFirestore.isBeingRoom(roomId: roomId) {
            guard let userId = UserDataStore.shared.signInUser?.userId else { return }
            let player = Player(userId: userId, isHost: isHost)
            let encoded = try! JSONEncoder().encode(player)
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).setData(jsonObject)
                try await Firestore.firestore().collection("Users").document(userId).setData(["beingRoom": roomId], merge: true)
            } catch {
                print(error)
            }
        }
    }
}
