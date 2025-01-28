//
//  FriendRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/12/09.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FriendShipRepository {
//    create
    static func sendFriendRequest(consenter: String) async {
        if await !checkRecieveRequest(consenter: consenter) {
            guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
            let friendShip = FriendShip(proposerUserId: myUserId, consentUserId: consenter)
            let friendShipEncoded = try! JSONEncoder().encode(friendShip)
            let notice = Notice(senderUserId: myUserId)
            let noticeEncoded = try! JSONEncoder().encode(notice)
            do {
                guard let friendShipJsonObject = try JSONSerialization.jsonObject(with: friendShipEncoded, options: []) as? [String: Any] else { return }
                guard let noticeJsonObject = try JSONSerialization.jsonObject(with: noticeEncoded, options: []) as? [String: Any] else { return }
                try await Firestore.firestore().collection("FriendShips").document(friendShip.friendShipId).setData(friendShipJsonObject)
                try await Firestore.firestore().collection("Users").document(consenter).collection("Notices").document(notice.noticeId).setData(noticeJsonObject)
                try await Firestore.firestore().collection("Users").document(myUserId).updateData(["friendShips": FieldValue.arrayUnion([friendShip.friendShipId])])
                try await Firestore.firestore().collection("Users").document(consenter).updateData(["friendShips": FieldValue.arrayUnion([friendShip.friendShipId])])
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                UserDataStore.shared.signInUser?.friendShips.append(friendShip.friendShipId)
            }
        } else {
            await becomeFriend(consenter: consenter)
        }
    }
    
//    check
    static func checkRecieveRequest(consenter: String) async -> Bool {
        guard let myUser = UserDataStore.shared.signInUser else { return false }
        let friendShips = myUser.friendShips
        for friendShipId in friendShips {
            let friendShip = await getFriendShip(friendShipId: friendShipId)
            if friendShip.consenterUserId == consenter { return true }
        }
        return false
    }
    
    static func isExists(pertnerUserId: String) -> Bool {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return false }
        let myFriendShips = FriendDataStore.shared.friendShips.filter { $0.proposerUserId == myUserId || $0.consenterUserId == myUserId }
        let friendShips = myFriendShips.filter { $0.proposerUserId == pertnerUserId || $0.consenterUserId == pertnerUserId }
        return !friendShips.isEmpty
    }
    
//    get
    static func getFriendShip(friendShipId: String) async -> FriendShip {
        do {
            let document = try await Firestore.firestore().collection("FriendShips").document(friendShipId).getDocument()
            return try document.data(as: FriendShip.self)
        } catch {
            print(error)
            return FriendShip()
        }
    }
    
    static func getAllMyFriendShips() async {
        guard let friendShipsId = UserDataStore.shared.signInUser?.friendShips else { return }
        for friendShipId in friendShipsId {
            let friendShip = await getFriendShip(friendShipId: friendShipId)
            FriendDataStore.shared.friendShips.append(noDuplicate: friendShip)
        }
    }
    
//    update
    static func becomeFriend(consenter: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let formatter = ISO8601DateFormatter()
        let date = formatter.string(from: Date())
        do {
            guard let documentId = try await Firestore.firestore().collection("FriendShip").whereField("proposerUserId", isEqualTo: myUserId).whereField("consnterUserId", isEqualTo: consenter).getDocuments().documents.first?.documentID else { return }
            try await Firestore.firestore().collection("FriendShip").document(documentId).updateData(["executionDate": date, "isFriend": true])
        } catch {
            print(error)
        }
    }
    
//    delete
    static func deleteFriend(friendShipId: String, pertnerUserId: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("FriendShips").document(friendShipId).delete()
            try await Firestore.firestore().collection("Users").document(myUserId).updateData(["friendShips": FieldValue.arrayRemove([friendShipId])])
            try await Firestore.firestore().collection("Users").document(pertnerUserId).updateData(["friendShips": FieldValue.arrayRemove([friendShipId])])
        } catch {
            print(error)
        }
    }
    
//    observe
    static func observeFriend() {
        guard let me = UserDataStore.shared.signInUser else { return }
        let listener = Firestore.firestore().collection("FriendShips").whereField("friendShipId", arrayContains: me.friendShips).addSnapshotListener { QuerySnapshot, error in
            guard let documentChanges = QuerySnapshot?.documentChanges else { return }
            for documentChange in documentChanges {
                do {
                    let document = documentChange.document
                    let friendShips = try document.data(as: FriendShip.self)
                    switch documentChange.type {
                    case .added:
                        DispatchQueue.main.async {
                            FriendDataStore.shared.friendShips.append(noDuplicate: friendShips)
                        }
                    case .modified:
                        DispatchQueue.main.async {
                            FriendDataStore.shared.friendShips.append(noDuplicate: friendShips)
                        }
                    case .removed:
                        DispatchQueue.main.async {
                            FriendDataStore.shared.friendShips.remove(friendShip: friendShips)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.friend] = listener
        }
    }
}
