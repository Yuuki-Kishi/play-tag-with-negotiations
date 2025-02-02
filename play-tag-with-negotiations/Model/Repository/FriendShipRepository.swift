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
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let friendShip = FriendShip(proposerUserId: myUserId, consenterUserId: consenter)
        let friendShipEncoded = try! JSONEncoder().encode(friendShip)
        let notice = Notice(senderUserId: myUserId)
        let noticeEncoded = try! JSONEncoder().encode(notice)
        do {
            guard let friendShipJsonObject = try JSONSerialization.jsonObject(with: friendShipEncoded, options: []) as? [String: Any] else { return }
            guard let noticeJsonObject = try JSONSerialization.jsonObject(with: noticeEncoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("FriendShips").document(friendShip.friendShipId).setData(friendShipJsonObject)
            try await Firestore.firestore().collection("Users").document(consenter).collection("Notices").document(notice.noticeId).setData(noticeJsonObject)
            try await Firestore.firestore().collection("Users").document(myUserId).updateData(["friendUsers": FieldValue.arrayUnion([consenter])])
            try await Firestore.firestore().collection("Users").document(consenter).updateData(["friendUsers": FieldValue.arrayUnion([myUserId])])
        } catch {
            print(error)
        }
    }
    
//    check
    static func isExists(pertnerUserId: String) -> Bool {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return false }
        let friendShipId = [myUserId, pertnerUserId].sorted().joined(separator: "_")
        if let friendShip = FriendDataStore.shared.friendShips.firstIndex(where: { $0.friendShipId == friendShipId }) { return true }
        return false
    }
    
//    get
    
    
//    update
    static func becomeFriend(consenter: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let friendShipId = [myUserId, consenter].sorted().joined(separator: "_")
        let formatter = ISO8601DateFormatter()
        let date = formatter.string(from: Date())
        do {
            try await Firestore.firestore().collection("FriendShips").document(friendShipId).updateData(["executionDate": date, "status": FriendShip.FriendShipStatus.accepted.rawValue])
        } catch {
            print(error)
        }
    }
    
//    delete
    static func deleteFriend(pertnerUserId: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let friendShipId = [myUserId, pertnerUserId].sorted().joined(separator: "_")
        do {
            try await Firestore.firestore().collection("FriendShips").document(friendShipId).delete()
            try await Firestore.firestore().collection("Users").document(myUserId).updateData(["friendUsers": FieldValue.arrayRemove([pertnerUserId])])
            try await Firestore.firestore().collection("Users").document(pertnerUserId).updateData(["friendUsers": FieldValue.arrayRemove([myUserId])])
        } catch {
            print(error)
        }
    }
    
//    observe
    static func observeFriend() {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let listener = Firestore.firestore().collection("FriendShips").whereFilter(Filter.orFilter([Filter.whereField("proposerUserId", isEqualTo: myUserId), Filter.whereField("consenterUserId", isEqualTo: myUserId)])).addSnapshotListener { QuerySnapshot, error in
            guard let documentChanges = QuerySnapshot?.documentChanges else { return }
            for documentChange in documentChanges {
                Task {
                    do {
                        let document = documentChange.document
                        var friendShips = try document.data(as: FriendShip.self)
                        let pertnerUserId = myUserId == friendShips.proposerUserId ? friendShips.consenterUserId : friendShips.proposerUserId
                        guard let pertnerUser = await UserRepository.getUserData(userId: pertnerUserId) else { return }
                        friendShips.pertnerUser = pertnerUser
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
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.friendShips] = listener
        }
    }
}
