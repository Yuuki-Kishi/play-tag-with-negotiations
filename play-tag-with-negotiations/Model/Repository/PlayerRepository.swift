//
//  PlayerRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/12/01.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class PlayerRepository {
//    create
    static func enterRoom(roomId: String, isHost: Bool) async {
        if await !Check.isBeingRoom(roomId: roomId) {
            guard let userId = UserDataStore.shared.signInUser?.userId else { return }
            let player = Player(playerUserId: userId, isHost: isHost)
            let encoded = try! JSONEncoder().encode(player)
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).setData(jsonObject)
                try await Firestore.firestore().collection("Users").document(userId).setData(["beingRoomId": roomId], merge: true)
            } catch {
                print(error)
            }
        }
    }
    
//    check
    
//    get
    static func getPlayer(userId: String) async -> Player? {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).getDocument()
            let player = try document.data(as: Player.self)
            return player
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getAllPlayers() async -> [Player] {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            let documents = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").getDocuments().documents
            var players: [Player] = []
            for document in documents {
                let player = try document.data(as: Player.self)
                players.append(noDuplicate: player)
            }
            return players
        } catch {
            print(error)
        }
        return []
    }
    
    static func getAlivePlayers() async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let players = await getAllPlayers().filter { $0.isCaptured == false }
        let alivePlayers = OperationPlayers.getAlivePlayers(players: players)
        let isAliveMe = alivePlayers.contains(where: { $0.playerUserId == myUserId })
        if !isAliveMe { await Update.wasCaptured() }
        DispatchQueue.main.async {
            PlayerDataStore.shared.playerArray = []
        }
        for playerData in players {
            var player = playerData
            let isAlive = alivePlayers.contains { $0.playerUserId == player.playerUserId }
            if !isAlive {
                player.isCaptured = true
            }
            DispatchQueue.main.async {
                PlayerDataStore.shared.playerArray.append(noDuplicate: player)
            }
        }
        let aliveFugitiveCount = OperationPlayers.getAliveFugitives(players: players).count
        if aliveFugitiveCount == 0 {
            await Update.gameEnd()
        }
    }
//    update
    
    static func playerUpToHost(roomId: String, nextHostUserId: String) async {
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(nextHostUserId).updateData(["isHost": true])
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["hostUserId": nextHostUserId])
        } catch {
            print(error)
        }
    }
    
    static func isDecidedToFalse() async {
        if !PlayerDataStore.shared.playerArray.me.isCaptured {
            let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
            guard let userId = UserDataStore.shared.signInUser?.userId else { return }
            do {
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isDecided": false])
            } catch {
                print(error)
            }
        }
    }
    
    static func grantMePoint(howMany: Int) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        await grantPoint(userId: userId, howMany: howMany)
    }
    
    static func grantPoint(userId: String, howMany: Int) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        guard let nowPoint = PlayerDataStore.shared.playerArray.first(where: { $0.playerUserId == userId })?.point else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["point": nowPoint + howMany])
        } catch {
            print(error)
        }
    }
    
    static func confiscateMePoint(howMany: Int) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        await confiscatePoint(userId: userId, howMany: howMany)
    }
    
    static func confiscatePoint(userId: String, howMany: Int) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        guard let nowPoint = PlayerDataStore.shared.playerArray.first(where: { $0.playerUserId == userId })?.point else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["point": nowPoint - howMany])
        } catch {
            print(error)
        }
    }
    
    static func nonCatchablePlayer(userId: String) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isCanCapture": false])
        } catch {
            print(error)
        }
    }
    
    static func catchablePlayer(userId: String) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isCanCapture": true])
        } catch {
            print(error)
        }
    }
    
//    delete
    static func exitRoom(roomId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).delete()
            try await Firestore.firestore().collection("Users").document(userId).updateData(["beingRoomId": FieldValue.delete()])
        } catch {
            print(error)
        }
    }
    
    static func hostExitRoom(roomId: String) async {
        guard let nextHostUserId = PlayerDataStore.shared.playerArray.guests.randomElement() else { return }
        await Update.playerUpToHost(roomId: roomId, nextHostUserId: nextHostUserId.playerUserId)
        await exitRoom(roomId: roomId)
    }
    
//    observe
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
    
    static func observeMyPropaty() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(myUserId).addSnapshotListener { DocumentSnapshot, error in
            do {
                guard let player = try DocumentSnapshot?.data(as: Player.self) else { return }
                var me = PlayerDataStore.shared.playerArray.me
                me.point = player.point
                me.isDecided = player.isDecided
                DispatchQueue.main.async {
                    PlayerDataStore.shared.playerArray.append(noDuplicate: me)
                }
            } catch {
                print(error)
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.myPropaty] = listener
        }
    }
}
