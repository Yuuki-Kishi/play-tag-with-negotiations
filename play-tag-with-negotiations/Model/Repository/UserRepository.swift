//
//  UserRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/12/01.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class UserRepository {
//    create
    static func createUser(user: User) async {
        let encoded = try! JSONEncoder().encode(user)
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("Users").document(user.userId).setData(jsonObject)
        } catch {
            print(error)
        }
    }
    
//    check
    static func isExists(userId: String) async -> Bool {
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            if document.exists { return true }
        } catch {
            print("Error getting document: \(error)")
            return true
        }
        return false
    }
    
    static func isBeingRoom() async -> Bool {
        if let currentRoomId = await getCurrentRoomId() { return true }
        return false
    }
    
//    get
    static func getUserData(userId: String) async -> User? {
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            var user = try document.data(as: User.self)
            user.iconData = await Download.getIconImage(iconUrl: user.iconUrl)
            return user
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getCurrentRoomId() async -> String? {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return nil }
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            guard let currentRoomId = document.get("currentRoomId") as? String else { return nil }
            return currentRoomId
        } catch {
            print(error)
        }
        return nil
    }
    
//    update
    static func updateUserName(newName: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).updateData(["userName": newName])
        } catch {
            print(error)
        }
    }
    
    static func updateSignInType(user: User) async {
        do {
            try await Firestore.firestore().collection("Users").document(user.userId).updateData(["signInType": user.signInType.rawValue])
        } catch {
            print(error)
        }
    }
    
    static func updateprofile(newProfile: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).updateData(["profile": newProfile])
        } catch {
            print(error)
        }
    }
    
    static func updateIconUrl(iconUrl: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).updateData(["iconUrl": iconUrl])
        } catch {
            print(error)
        }
    }
    
    static func addPlayedRoomIds(roomId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let playedRoomId = PlayedRoomId(roomId: roomId)
        let encoded = try! JSONEncoder().encode(playedRoomId)
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("Users").document(userId).setData(["currentRoomId": roomId], merge: true)
            try await Firestore.firestore().collection("Users").document(userId).updateData(["playedRoomIds": FieldValue.arrayUnion([jsonObject])])
        } catch {
            print(error)
        }
    }
    
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
    
//    delete
    static func finishGame() async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).updateData(["currentRoomId": FieldValue.delete()])
        } catch {
            print(error)
        }
    }
    
//    observe
    static func observeUserData() {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let listener = Firestore.firestore().collection("Users").document(userId).addSnapshotListener { documentSnapshot, error in
            Task {
                do {
                    guard var user = try documentSnapshot?.data(as: User.self) else { return }
                    user.iconData = await Download.getIconImage(iconUrl: user.iconUrl)
                    DispatchQueue.main.async {
                        UserDataStore.shared.signInUser = user
                    }
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.myUserData] = listener
        }
    }
    
    static func observeUsersData() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").addSnapshotListener { querySnapshot, error in
            guard let documentChanges = querySnapshot?.documentChanges else { return }
            Task {
                for documentChange in documentChanges {
                    guard let user = await getUserData(userId: documentChange.document.documentID) else { continue }
                    switch documentChange.type {
                    case .added:
                        DispatchQueue.main.async {
                            PlayerDataStore.shared.userArray.append(noDuplicate: user)
                        }
                    case .modified:
                        DispatchQueue.main.async {
                            PlayerDataStore.shared.userArray.append(noDuplicate: user)
                        }
                    case .removed:
                        DispatchQueue.main.async {
                            PlayerDataStore.shared.userArray.remove(userId: user.userId)
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.usersData] = listener
        }
    }
}
