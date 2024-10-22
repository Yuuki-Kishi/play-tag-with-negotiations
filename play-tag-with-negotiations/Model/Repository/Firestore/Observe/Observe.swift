//
//  ObserveFirestor.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/19.
//

import Foundation
import FirebaseFirestore

class Observe {
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
    
    static func observeRoomField() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).addSnapshotListener { DocumentSnapshot, error in
            do {
                guard let playingRoom = try DocumentSnapshot?.data(as: PlayTagRoom.self) else { return }
                if PlayerDataStore.shared.playingRoom.phaseNow < playingRoom.phaseNow {
                    Task {
                        await Check.checkDeals()
                        await Update.isDecidedToFalse()
                        await Get.getAlivePlayers()
                    }
                }
                DispatchQueue.main.async {
                    PlayerDataStore.shared.playingRoom = playingRoom
                }
            } catch {
                print(error)
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.roomField] = listener
        }
    }
    
    static func observeNotice() {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let listener = Firestore.firestore().collection("Users").document(myUserId).collection("Notices").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            DispatchQueue.main.async {
                UserDataStore.shared.noticeArray = []
            }
            Task {
                for document in documents {
                    do {
                        let noticeId = try document.data(as: Notice.self).noticeId.uuidString
                        guard let notice = await Get.getNotice(noticeId: noticeId) else { return }
                        DispatchQueue.main.async {
                            UserDataStore.shared.noticeArray.append(noDuplicate: notice)
                            UserDataStore.shared.noticeArray.sort { $0.sendTime > $1.sendTime }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.notice] = listener
        }
    }
    
    static func observePlayers() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").addSnapshotListener { querySnapshot, error in
            guard let documentChanges = querySnapshot?.documentChanges else { return }
            for documentChange in documentChanges {
                do {
                    let addedDocument = documentChange.document
                    let player = try addedDocument.data(as: Player.self)
                    switch documentChange.type {
                    case .added:
                        Task {
                            guard let user = await Get.getUserData(userId: addedDocument.documentID) else { return }
                            DispatchQueue.main.async {
                                PlayerDataStore.shared.userArray.append(noDuplicate: user)
                                PlayerDataStore.shared.playerArray.append(noDuplicate: player)
                            }
                        }
                    case .modified:
                        DispatchQueue.main.async {
                            PlayerDataStore.shared.playerArray.append(noDuplicate: player)
                        }
                    case .removed:
                        DispatchQueue.main.async {
                            PlayerDataStore.shared.userArray.delete(userId: player.playerUserId)
                            PlayerDataStore.shared.playerArray.delete(userId: player.playerUserId)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.players] = listener
        }
    }
    
    static func observeMyIsDecided() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(myUserId).addSnapshotListener { DocumentSnapshot, error in
            do {
                guard let myIsDecided = try DocumentSnapshot?.data(as: Player.self).isDecided else { return }
                guard let index = PlayerDataStore.shared.playerArray.firstIndex(where: { $0 == PlayerDataStore.shared.playerArray.me }) else { return }
                DispatchQueue.main.async {
                    PlayerDataStore.shared.playerArray[index].isDecided = myIsDecided
                }
            } catch {
                print(error)
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.myIsDecided] = listener
        }
    }
    
    static func observeIsDecided() {
        if PlayerDataStore.shared.playerArray.me.isHost {
            let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
            let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").whereField("isDecided", isEqualTo: true).addSnapshotListener { QuerySnapshot, error in
                guard let documents = QuerySnapshot?.documents else { return }
                let playerCount = PlayerDataStore.shared.playerArray.count
                if playerCount <= documents.count {
                    Task { await Update.moveToNextPhase() }
                }
            }
            DispatchQueue.main.async {
                UserDataStore.shared.listeners[UserDataStore.listenerType.isDecided] = listener
            }
        }
    }
    
    static func observePublicRooms() {
        let listener = Firestore.firestore().collection("PlayTagRooms").whereField("isPublic", isEqualTo: true).addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else { return }
            DispatchQueue.main.async {
                RoomDataStore.shared.publicRoomsArray = []
            }
            for document in documents {
                Task {
                    guard let publicRoom = await Get.getRoomData(roomId: document.documentID) else { return }
                    DispatchQueue.main.async {
                        RoomDataStore.shared.publicRoomsArray.append(publicRoom)
                    }
                    
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.publicRooms] = listener
        }
    }
    
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
    
    static func observeNegotiations() {
        guard let version = Double(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String) else { return }
        DispatchQueue.main.async {
            PlayerDataStore.shared.negotiationArray = []
        }
        let listener = Firestore.firestore().collection("Negotiations").whereField("version", isLessThanOrEqualTo: version).addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else { return }
            for document in documents {
                do {
                    let negotiation = try document.data(as: Negotiation.self)
                    DispatchQueue.main.async {
                        PlayerDataStore.shared.negotiationArray.append(noDuplicate: negotiation)
                    }
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.negotiation] = listener
        }
    }
    
    static func observeDeals() {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").whereField("condition", isNotEqualTo: "fulfilled").addSnapshotListener { QuerySnapshot, error in
            DispatchQueue.main.async {
                PlayerDataStore.shared.dealArray = []
            }
            guard let documents = QuerySnapshot?.documents else { return }
            for document in documents {
                Task {
                    do {
                        let deal = try document.data(as: Deal.self)
                        if deal.proposerUserId == myUserId || deal.targetUserId == myUserId {
                            DispatchQueue.main.async {
                                PlayerDataStore.shared.dealArray.append(noDuplicate: deal)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.deal] = listener
        }
    }
    
    static func observeMyPoint() {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(myUserId).addSnapshotListener { snapshot, error in
            do {
                guard let player = try snapshot?.data(as: Player.self) else { return }
                var me = PlayerDataStore.shared.playerArray.me
                me.point = player.point
                DispatchQueue.main.async {
                    PlayerDataStore.shared.playerArray.append(noDuplicate: me)
                }
            } catch {
                print(error)
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.myPoint] = listener
        }
    }
}
