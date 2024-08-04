//
//  Read.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ReadToFirestore {
    static func isWroteUser(userId: String) async -> Bool {
        do {
            let userDocuments = try await Firestore.firestore().collection("Users").whereField("userId", isEqualTo: userId).getDocuments()
            for userDocument in userDocuments.documents {
                if userDocument.documentID == userId { return true }
            }
            return false
        } catch {
            print("Error getting document: \(error)")
            return true
        }
    }
    
    static func isBeingRoom(roomId: String) async -> Bool {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return true }
        do {
            let players = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").whereField("userId", isEqualTo: userId).getDocuments()
            if players.isEmpty { return false }
        } catch {
            print(error)
        }
        return true
    }
    
    static func getBeingRoomId() async -> String? {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return nil }
        do {
            let userDocument = try await Firestore.firestore().collection("Users").document(userId).getDocument().data()
            guard let beingRoomId = userDocument?["beingRoomId"] as? String else { return nil }
            return beingRoomId
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getUserData(userId: String) async -> User? {
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            if document.exists {
                var user = try document.data(as: User.self)
                user.iconData = await ReadToStorage.getIconImage(iconUrl: user.iconUrl)
                return user
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getPlayers(roomId: String) async {
        do {
            let documents = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").getDocuments()
            DispatchQueue.main.async {
                PlayerDataStore.shared.guestUserArray = []
                PlayerDataStore.shared.guestPlayerArray = []
                PlayerDataStore.shared.userArray = []
                PlayerDataStore.shared.playerArray = []
            }
            for document in documents.documents {
                Task {
                    let player = try document.data(as: Player.self)
                    guard let user = await getUserData(userId: player.userId) else { return }
                    guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
                    if player.userId == myUserId {
                        DispatchQueue.main.async {
                            PlayerDataStore.shared.player = player
                        }
                    }
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
                        PlayerDataStore.shared.userArray.append(ifNoOverlap: user)
                        PlayerDataStore.shared.playerArray.append(ifNoOverlap: player)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    static func checkIsThereRoom(roomId: String) async -> Bool {
        do {
            let playTagRooms = try await Firestore.firestore().collection("PlayTagRooms").getDocuments()
            for playTagRoom in playTagRooms.documents {
                if playTagRoom.documentID == roomId { return true }
            }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    static func isNotOverPlayer(roomId: String) async -> Bool {
        do {
            let playersCount = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").getDocuments().count
            let playTagRoom = await getRoomData(roomId: roomId)
            let playingPlayerCount = playTagRoom.chaserNumber + playTagRoom.fugitiveNumber
            if playersCount < playingPlayerCount {
                return true
            }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    static func getRoomData(roomId: String) async -> PlayTagRoom {
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).getDocument()
            let playTagRoom = try document.data(as: PlayTagRoom.self)
            return playTagRoom
        } catch {
            print(error)
        }
        return PlayTagRoom()
    }
}
