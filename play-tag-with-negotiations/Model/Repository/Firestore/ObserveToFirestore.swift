//
//  ObserveFirestor.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/19.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ObserveToFirestore {
    static func observeUserData() {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        Firestore.firestore().collection("Users").document(userId).addSnapshotListener { documentSnapshot, error in
            Task {
                do {
                    guard let user = try documentSnapshot?.data(as: User.self) else { return }
                    let iconData = await ReadToStorage.getIconImage(iconUrl: user.iconUrl)
                    DispatchQueue.main.async {
                        UserDataStore.shared.signInUser = user
                        UserDataStore.shared.signInUser?.iconData = iconData
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    static func observeRoomField() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        Firestore.firestore().collection("PlayTagRooms").document(roomId).addSnapshotListener { DocumentSnapshot, error in
            do {
                guard let playingRoom = try DocumentSnapshot?.data(as: PlayTagRoom.self) else { return }
                if PlayerDataStore.shared.playingRoom.phaseNow < playingRoom.phaseNow {
                    Task {
                        await ReadToFirestore.getAlivePlayers()
                    }
                }
                DispatchQueue.main.async {
                    PlayerDataStore.shared.playingRoom = playingRoom
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func observeNotice() {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        Firestore.firestore().collection("PlayTagRooms").document(myUserId).collection("Notice").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            DispatchQueue.main.async {
                UserDataStore.shared.noticeArray = []
            }
            Task {
                for document in documents {
                    do {
                        let noticeId = try document.data(as: Notice.self).noticeId.uuidString
                        guard let notice = await ReadToFirestore.getNotice(noticeId: noticeId) else { return }
                        DispatchQueue.main.async {
                            UserDataStore.shared.noticeArray.append(notice)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    static func observePlayers() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").addSnapshotListener { querySnapshot, error in
            if !PlayerDataStore.shared.playingRoom.isPlaying {
                guard let documents = querySnapshot?.documents else { return }
                DispatchQueue.main.async {
                    PlayerDataStore.shared.guestUserArray = []
                    PlayerDataStore.shared.guestPlayerArray = []
                    PlayerDataStore.shared.playerArray = []
                }
                for document in documents {
                    Task {
                        do {
                            let player = try document.data(as: Player.self)
                            guard let user = await ReadToFirestore.getUserData(userId: player.userId) else { return }
                            if player.isHost {
                                DispatchQueue.main.async {
                                    PlayerDataStore.shared.hostUser = user
                                    PlayerDataStore.shared.hostPlayer = player
                                }
                            } else {
                                DispatchQueue.main.async {
                                    PlayerDataStore.shared.guestUserArray.append(ifNoOverlap: user)
                                    PlayerDataStore.shared.guestPlayerArray.append(ifNoOverlap: player)
                                }
                            }
                            DispatchQueue.main.async {
                                PlayerDataStore.shared.playerArray.append(ifNoOverlap: player)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    static func observeMyIsDecided() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(myUserId).addSnapshotListener { DocumentSnapshot, error in
            do {
                guard let myIsDecided = try DocumentSnapshot?.data(as: Player.self).isDecided else { return }
                DispatchQueue.main.async {
                    PlayerDataStore.shared.player.isDecided = myIsDecided
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func observeIsDecided() {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let hostUserId = PlayerDataStore.shared.playingRoom.hostUserId
        if myUserId == hostUserId {
            let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
            Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").addSnapshotListener { QuerySnapshot, error in
                do {
                    guard let documents = QuerySnapshot?.documents else { return }
                    var players: [Player] = []
                    for document in documents {
                        let player = try document.data(as: Player.self)
                        players.append(player)
                    }
                    let decidedPlayerCount = players.filter { $0.isDecided }.count
                    let playerCount = players.count
                    if decidedPlayerCount == playerCount {
                        Task {
                            await UpdateToFirestore.moveToNextPhase()
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    static func observePublicRooms() {
        Firestore.firestore().collection("PlayTagRooms").whereField("isPublic", isEqualTo: true).addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else { return }
            RoomDataStore.shared.publicRoomsArray = []
            for document in documents {
                Task {
                    let publicRoom = await ReadToFirestore.getRoomData(roomId: document.documentID)
                    DispatchQueue.main.async {
                        RoomDataStore.shared.publicRoomsArray.append(publicRoom)
                    }
                    
                }
            }
        }
    }
    
    static func observeFriend() {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        Firestore.firestore().collection("Users").document(userId).collection("Friends").addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else { return }
            FriendDataStore.shared.friendArray = []
            FriendDataStore.shared.requestUserArray = []
            for document in documents {
                Task {
                    do {
                        let friend = try document.data(as: Friend.self)
                        guard let friendUser = await ReadToFirestore.getUserData(userId: document.documentID) else { return }
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
    }
    
//    static func observePlayer() {
//        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
//        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
//        Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).addSnapshotListener { documentSnapshot, error in
//            do {
//                guard let player = try documentSnapshot?.data(as: Player.self) else { return }
//                PlayerDataStore.shared.player = player
//            } catch {
//                print(error)
//            }
//            
//        }
//    }
}
