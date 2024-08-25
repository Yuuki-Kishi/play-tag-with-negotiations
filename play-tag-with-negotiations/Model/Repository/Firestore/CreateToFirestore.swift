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
                try await Firestore.firestore().collection("Users").document(userId).setData(["beingRoomId": roomId], merge: true)
            } catch {
                print(error)
            }
        }
    }
    
    static func sendFriendRequest(to: String) async {
        if await !ReadToFirestore.isRecieveRequest(from: to) {
            guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
            let pertnerFriend = Friend(pertnerUserId: myUserId)
            let myFriend = Friend(pertnerUserId: to)
            let pertnerEncoded = try! JSONEncoder().encode(pertnerFriend)
            let myEncoded = try! JSONEncoder().encode(myFriend)
            let notice = Notice(userId: myUserId)
            let noticeEncoded = try! JSONEncoder().encode(notice)
            do {
                guard let pertnerJsonObject = try JSONSerialization.jsonObject(with: pertnerEncoded, options: []) as? [String: Any] else { return }
                guard let myJsonObject = try JSONSerialization.jsonObject(with: myEncoded, options: []) as? [String: Any] else { return }
                guard let noticeJsonObject = try JSONSerialization.jsonObject(with: noticeEncoded, options: []) as? [String: Any] else { return }
                try await Firestore.firestore().collection("Users").document(to).collection("Friends").document(myUserId).setData(pertnerJsonObject)
                try await Firestore.firestore().collection("Users").document(myUserId).collection("Friends").document(to).setData(myJsonObject)
                try await Firestore.firestore().collection("Users").document(to).collection("Notices").document(notice.noticeId.uuidString).setData(noticeJsonObject)
            } catch {
                print(error)
            }
        } else {
            await UpdateToFirestore.becomeFriend(friendUserId: to)
        }
    }
    
    static func sendInviteNotice(users: Set<User>, roomId: String) async {
        do {
            guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
            for user in users {
                let notice = Notice(userId: myUserId, roomId: roomId)
                let encoded = try! JSONEncoder().encode(notice)
                guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
                try await Firestore.firestore().collection("Users").document(user.userId).collection("Notices").document(notice.noticeId.uuidString).setData(jsonObject)
            }
        } catch {
            print(error)
        }
    }
}
