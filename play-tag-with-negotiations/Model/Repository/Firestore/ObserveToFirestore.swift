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
            DispatchQueue.main.async {
                do {
                    UserDataStore.shared.signInUser = try documentSnapshot?.data(as: User.self)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    static func observeRoomField(roomId: String) {
        Firestore.firestore().collection("PlayTagRooms").document(roomId).addSnapshotListener { DocumentSnapshot, error in
            DispatchQueue.main.async {
                do {
                    guard let playingRoom = try DocumentSnapshot?.data(as: PlayTagRoom.self) else { return }
                    PlayerDataStore.shared.playingRoom = playingRoom
                } catch {
                    print(error)
                }
            }
        }
    }
    
    static func observePlayer() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            DispatchQueue.main.async {
                PlayerDataStore.shared.guestUserArray = []
                PlayerDataStore.shared.guestPlayerArray = []
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
                            PlayerDataStore.shared.playerUserArray.append(ifNoOverlap: user)
                            PlayerDataStore.shared.playerPlayerArray.append(ifNoOverlap: player)
                        }
                    } catch {
                        print(error)
                    }
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
}
