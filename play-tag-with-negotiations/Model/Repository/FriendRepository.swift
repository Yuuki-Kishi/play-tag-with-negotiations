//
//  FriendRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/12/09.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FriendRepository {
//    create
    static func sendFriendRequest(to: String) async {
        if await !Check.checkRecieveRequest(from: to) {
            guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
            let pertner = Friend(pertnerUserId: myUserId)
            let me = Friend(pertnerUserId: to)
            let pertnerEncoded = try! JSONEncoder().encode(pertner)
            let meEncoded = try! JSONEncoder().encode(me)
            let notice = Notice(senderUserId: myUserId)
            let noticeEncoded = try! JSONEncoder().encode(notice)
            do {
                guard let pertnerJsonObject = try JSONSerialization.jsonObject(with: pertnerEncoded, options: []) as? [String: Any] else { return }
                guard let meJsonObject = try JSONSerialization.jsonObject(with: meEncoded, options: []) as? [String: Any] else { return }
                guard let noticeJsonObject = try JSONSerialization.jsonObject(with: noticeEncoded, options: []) as? [String: Any] else { return }
                try await Firestore.firestore().collection("Users").document(to).collection("Friends").document(myUserId).setData(pertnerJsonObject)
                try await Firestore.firestore().collection("Users").document(myUserId).collection("Friends").document(to).setData(meJsonObject)
                try await Firestore.firestore().collection("Users").document(to).collection("Notices").document(notice.noticeId.uuidString).setData(noticeJsonObject)
            } catch {
                print(error)
            }
        } else {
            await Update.becomeFriend(friendUserId: to)
        }
    }
    
//    check
    static func checkRecieveRequest(from: String) async -> Bool {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return false }
        do {
            let document = try await Firestore.firestore().collection("Users").document(myUserId).collection("Friends").document(from).getDocument()
            if document.exists { return true }
        } catch {
            print(error)
        }
        return false
    }
    
//    get
    
//    update
    static func becomeFriend(friendUserId: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let formatter = ISO8601DateFormatter()
        let time = formatter.string(from: Date())
        do {
            try await Firestore.firestore().collection("Users").document(myUserId).collection("Friends").document(friendUserId).updateData(["isFriend": true, "editedTime": time])
            try await Firestore.firestore().collection("Users").document(friendUserId).collection("Friends").document(myUserId).updateData(["isFriend": true, "editedTime": time])
        } catch {
            print(error)
        }
    }
    
//    delete
    static func deleteFriend(friendUserId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).collection("Friends").document(friendUserId).delete()
            try await Firestore.firestore().collection("Users").document(friendUserId).collection("Friends").document(userId).delete()
        } catch {
            print(error)
        }
    }
    
//    observe
    static func observeFriend() {
        guard let user = UserDataStore.shared.signInUser else { return }
        let listener = Firestore.firestore().collection("Users").document(user.userId).collection("Friends").addSnapshotListener { QuerySnapshot, error in
            guard let documentChanges = QuerySnapshot?.documentChanges else { return }
            for documentChange in documentChanges {
                Task {
                    let document = documentChange.document
                    guard let friendUser = await Get.getUserData(userId: document.documentID) else { return }
                    let isFriend = user.friendsUserId.contains(document.documentID)
                    switch documentChange.type {
                    case .added:
                        DispatchQueue.main.async {
                            if isFriend {
                                FriendDataStore.shared.friendArray.append(noDuplicate: friendUser)
                            } else {
                                FriendDataStore.shared.requestUserArray.append(noDuplicate: friendUser)
                            }
                        }
                    case .modified:
                        DispatchQueue.main.async {
                            if isFriend {
                                FriendDataStore.shared.friendArray.append(noDuplicate: friendUser)
                            } else {
                                FriendDataStore.shared.requestUserArray.append(noDuplicate: friendUser)
                            }
                        }
                    case .removed:
                        DispatchQueue.main.async {
                            if isFriend {
                                guard let index = FriendDataStore.shared.friendArray.firstIndex(of: friendUser) else { return }
                                FriendDataStore.shared.friendArray.remove(at: index)
                            } else {
                                guard let index = FriendDataStore.shared.requestUserArray.firstIndex(of: friendUser) else { return }
                                FriendDataStore.shared.requestUserArray.remove(at: index)
                            }
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.friend] = listener
        }
    }
}
