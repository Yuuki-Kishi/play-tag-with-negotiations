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
        if let beingRoomId = await getBeingRoomId() { return true }
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
    
    static func getBeingRoomId() async -> String? {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return nil }
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            guard let beingRoomId = document.get("beingRoomId") as? String else { return nil }
            return beingRoomId
        } catch {
            print(error)
        }
        return nil
    }
    
//    update
    static func updateUserName(newName: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).setData(["userName": newName], merge: true)
        } catch {
            print(error)
        }
    }
    
    static func updateprofile(newProfile: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).setData(["profile": newProfile], merge: true)
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
                        await UserRepository.updateIconUrl(iconUrl: iconUrl)
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
    
//    delete
    static func finishGame() async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).updateData(["beingRoomId": FieldValue.delete()])
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
