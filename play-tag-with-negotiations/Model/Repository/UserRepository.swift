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
    static func create(user: User) async {
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
    
    static func isBeingRoom(roomId: String) async -> Bool {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return true }
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).getDocument()
            if !document.exists { return false }
        } catch {
            print(error)
        }
        return true
    }
    
//    get
    static func get(userId: String) async -> User? {
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            let friendsDocuments = try await Firestore.firestore().collection("Users").document(userId).collection("Friends").whereField("isFriend", isEqualTo: true).getDocuments().documents
            if document.exists {
                var friendsUserId: [String] = []
                for friendsDocument in friendsDocuments {
                    friendsUserId.append(friendsDocument.documentID)
                }
                var user = try document.data(as: User.self)
                user.iconData = await Download.getIconImage(iconUrl: user.iconUrl)
                user.friendsUserId = friendsUserId
                return user
            } else {
                return nil
            }
        } catch {
            print(error)
        }
        return nil
    }
    
//    static func getAllUsers() async -> [User] {
//        let players = await getAllPlayers()
//        for player in players {
//            guard let user = await get(userId: player.playerUserId) else { return }
//            DispatchQueue.main.async {
//                PlayerDataStore.shared.userArray.append(noDuplicate: user)
//            }
//        }
//    }
    
//    update
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
    
    static func uploadIconImage(selectedItem: PhotosPickerItem?) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
        guard let image = UIImage(data: data) else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        let storageRef = Storage.storage().reference().child(userId).child("icon.jpg")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error { print(error) }
            else {
                storageRef.downloadURL { (url, error) in
                    Task {
                        guard let iconUrl = url?.absoluteString else { return }
                        await Update.updateIconUrl(iconUrl: iconUrl)
                    }
                }
            }
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
    
//    observe
    static func observeUserData() {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let listener = Firestore.firestore().collection("Users").document(userId).addSnapshotListener { documentSnapshot, error in
            Task {
                do {
                    guard let user = try documentSnapshot?.data(as: User.self) else { return }
                    let friendsDocuments = try await Firestore.firestore().collection("Users").document(userId).collection("Friends").whereField("isFriend", isEqualTo: true).getDocuments().documents
                    var friendsUserId: [String] = []
                    for friendsDocument in friendsDocuments {
                        friendsUserId.append(friendsDocument.documentID)
                    }
                    let iconData = await Download.getIconImage(iconUrl: user.iconUrl)
                    DispatchQueue.main.async {
                        UserDataStore.shared.signInUser = user
                        UserDataStore.shared.signInUser?.friendsUserId = friendsUserId
                        UserDataStore.shared.signInUser?.iconData = iconData
                    }
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.userData] = listener
        }
    }
}
