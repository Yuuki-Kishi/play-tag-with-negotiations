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
    
    static func gameStart() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["isPlaying": true])
        } catch {
            print(error)
        }
    }
    
    static func randomInitialPosition() async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let horizontalCount = PlayerDataStore.shared.playingRoom.horizontalCount
        let  verticalCount = PlayerDataStore.shared.playingRoom.verticalCount
        let initialX = Int.random(in: 0 ..< horizontalCount)
        let initialY = Int.random(in: 0 ..< verticalCount)
        let initialPosition = PlayerPosition(x: initialX, y: initialY)
        let encoded = try! JSONEncoder().encode(initialPosition)
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(jsonObject)
        } catch {
            print(error)
        }
    }
    
    static func updatePosition(x: Int, y: Int) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let playerPosition = PlayerPosition(x: x, y: y)
        let encoded = try! JSONEncoder().encode(playerPosition)
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(jsonObject)
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isDecided": true])
        } catch {
            print(error)
        }
    }
    
    static func moveToNextPhase() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        let batch = Firestore.firestore().batch()
        let documentRef = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players")
        batch.updateData(["isDecided": true], forDocument: documentRef)
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["phaseNow": phaseNow + 1])
        } catch {
            print(error)
        }
    }
}
