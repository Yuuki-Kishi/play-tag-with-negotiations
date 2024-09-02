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
                    let iconData = await Download.getIconImage(iconUrl: user.iconUrl)
                    DispatchQueue.main.async {
                        UserDataStore.shared.signInUser = user
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
                DispatchQueue.main.async {
                    PlayerDataStore.shared.playingRoom = playingRoom
                }
                if PlayerDataStore.shared.playingRoom.phaseNow < playingRoom.phaseNow {
                    Task { await Get.getAlivePlayers() }
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
        DispatchQueue.main.async {
            PlayerDataStore.shared.playerArray = []
        }
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            for document in documents {
                Task {
                    do {
                        var player = try document.data(as: Player.self)
                        guard let user = await Get.getUserData(userId: player.playerUserId) else { return }
                        player.player = user
                        DispatchQueue.main.async {
                            PlayerDataStore.shared.playerArray.append(noDuplicate: player)
                        }
                    } catch {
                        print(error)
                    }
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
        if PlayerDataStore.shared.playerArray.isHost {
            let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
            let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").addSnapshotListener { QuerySnapshot, error in
                Task {
                    do {
                        guard let documents = QuerySnapshot?.documents else { return }
                        var players: [Player] = []
                        for document in documents {
                            var player = try document.data(as: Player.self)
                            guard let user = await Get.getUserData(userId: player.playerUserId) else { return }
                            player.player = user
                            players.append(player)
                        }
                        let decidedPlayerCount = players.filter { $0.isDecided }.count
                        let playerCount = players.count
                        if decidedPlayerCount == playerCount {
                            await Update.moveToNextPhase()
                        }
                    } catch {
                        print(error)
                    }
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
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        DispatchQueue.main.async {
            FriendDataStore.shared.friendArray = []
            FriendDataStore.shared.requestUserArray = []
        }
        let listener = Firestore.firestore().collection("Users").document(userId).collection("Friends").addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else { return }
            for document in documents {
                Task {
                    do {
                        let friend = try document.data(as: Friend.self)
                        guard let friendUser = await Get.getUserData(userId: document.documentID) else { return }
                        if friend.isFriend {
                            DispatchQueue.main.async {
                                FriendDataStore.shared.friendArray.append(friendUser)
                            }
                        } else {
                            DispatchQueue.main.async {
                                FriendDataStore.shared.requestUserArray.append(friendUser)
                            }
                        }
                    } catch {
                        print(error)
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
            UserDataStore.shared.listeners[UserDataStore.listenerType.negotiations] = listener
        }
    }
    
    static func getDeals(pertonerUserId: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        DispatchQueue.main.async {
            PlayerDataStore.shared.dealArray = []
        }
        let proposeListener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").whereField("proposerUserId", isEqualTo: myUserId).whereField("targetUserId", isEqualTo: pertonerUserId).addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else { return }
            for document in documents {
                Task {
                    do {
                        var deal = try document.data(as: Deal.self)
                        guard let negotiation = await Get.getNegotiation(negotiationId: deal.negotiationId) else { return }
                        guard let proposer = await Get.getUserData(userId: deal.proposerUserId) else { return }
                        guard let target = await Get.getUserData(userId: deal.targetUserId) else { return }
                        deal.negotiation = negotiation
                        deal.proposer = proposer
                        deal.target = target
                        DispatchQueue.main.async {
                            PlayerDataStore.shared.dealArray.append(ifNoOverlap: deal)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        let targetListener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").whereField("proposerUserId", isEqualTo: pertonerUserId).whereField("targetUserId", isEqualTo: myUserId).addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else { return }
            for document in documents {
                Task {
                    do {
                        var deal = try document.data(as: Deal.self)
                        guard let negotiation = await Get.getNegotiation(negotiationId: deal.negotiationId) else { return }
                        guard let proposer = await Get.getUserData(userId: deal.proposerUserId) else { return }
                        guard let target = await Get.getUserData(userId: deal.targetUserId) else { return }
                        deal.negotiation = negotiation
                        deal.proposer = proposer
                        deal.target = target
                        DispatchQueue.main.async {
                            PlayerDataStore.shared.dealArray.append(ifNoOverlap: deal)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.propose] = proposeListener
            UserDataStore.shared.listeners[UserDataStore.listenerType.target] = targetListener
        }
    }
}
