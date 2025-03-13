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
        if await !UserRepository.isBeingRoom() {
            guard let userId = UserDataStore.shared.signInUser?.userId else { return }
            let player = Player(playerUserId: userId, isHost: isHost)
            guard let playerNumber = await PlayTagRoomRepository.getRoomData(roomId: roomId)?.playerNumber else { return }
            let encoded = try! JSONEncoder().encode(player)
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).setData(jsonObject)
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["playerNumber": playerNumber + 1])
                try await Firestore.firestore().collection("Users").document(userId).setData(["beingRoomId": roomId], merge: true)
            } catch {
                print(error)
            }
        }
    }
    
    static func writeIsCatchable() async {
        if !PlayerDataStore.shared.playerArray.me.isChaser {
            let catchers = PlayerDataStore.shared.playerArray.filter { $0.isChaser }.map { $0.playerUserId }
            let roomId = PlayerDataStore.shared.playingRoom.roomId
            guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
            do {
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(myUserId).updateData(["catchers": catchers])
            } catch {
                print(error)
            }
        }
    }
    
//    check
    
//    get
    static func getPlayer(userId: String) async -> Player? {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
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
        let roomId = PlayerDataStore.shared.playingRoom.roomId
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
    
    static func getAlivePlayers(phaseNow: Int) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        var players = await getAllPlayers()
        let chasers = players.filter { $0.isChaser }
        let fugitives = players.filter { !$0.isChaser }
        fugitiveLoop: for fugitive in fugitives {
            guard let fugitivePosition = fugitive.move.first(where: { $0.phase == phaseNow }) else { continue }
            for chaser in chasers {
                guard let chaserPosition = chaser.move.first(where: { $0.phase == phaseNow }) else { continue }
                print("fugitiveUserId:", fugitive.playerUserId)
                print("fugitivePosition:", fugitivePosition)
                print("chaserPosition:", chaserPosition)
                if fugitivePosition == chaserPosition {
                    let isContain = fugitive.catchers.contains(chaser.playerUserId)
                    print("same position")
                    if isContain {
                        var newFugitive = fugitive
                        newFugitive.isCaptured = true
                        players.append(noDuplicate: newFugitive)
                        print("")
                        continue fugitiveLoop
                    }
                }
                print("")
            }
        }
        print("players:", players)
        print("")
        for player in players {
            DispatchQueue.main.async {
                PlayerDataStore.shared.playerArray.append(noDuplicate: player)
            }
            if player.isCaptured {
                if player.playerUserId == myUserId {
                    await PlayerRepository.wasCaptured()
                }
            } else {
                if player.isMe {
                    let nextMove = player.move.filter { $0.phase == phaseNow + 1 }
                    if nextMove.isEmpty {
                        await PlayerRepository.isDecidedToFalse()
                    }
                }
            }
        }
        if players.filter({ !$0.isChaser && !$0.isCaptured }).isEmpty {
            await PlayTagRoomRepository.gameFinished()
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
//        if !PlayerDataStore.shared.playerArray.me.isCaptured {
            let roomId = PlayerDataStore.shared.playingRoom.roomId
            guard let userId = UserDataStore.shared.signInUser?.userId else { return }
            do {
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isDecided": false])
            } catch {
                print(error)
            }
//        }
    }
    
    static func wasCaptured() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isDecided": true, "isCaptured": true])
        } catch {
            print(error)
        }
    }
    
    static func grantMePoint(howMany: Int) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        await grantPoint(userId: userId, howMany: howMany)
    }
    
    static func grantPoint(userId: String, howMany: Int) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
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
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        guard let nowPoint = PlayerDataStore.shared.playerArray.first(where: { $0.playerUserId == userId })?.point else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["point": nowPoint - howMany])
        } catch {
            print(error)
        }
    }
    
    static func nonCatcher(userId: String) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["catchers": FieldValue.arrayRemove([myUserId])])
        } catch {
            print(error)
        }
    }
    
    static func catcher(userId: String) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        var catchers = PlayerDataStore.shared.playerArray.me.catchers
        catchers.append(userId)
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(myUserId).updateData(["catchers": catchers])
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
        await playerUpToHost(roomId: roomId, nextHostUserId: nextHostUserId.playerUserId)
        await exitRoom(roomId: roomId)
    }
    
//    observe
    static func observePlayers() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").addSnapshotListener { querySnapshot, error in
            guard let documentChanges = querySnapshot?.documentChanges else { return }
            for documentChange in documentChanges {
                do {
                    let document = documentChange.document
                    let player = try document.data(as: Player.self)
                    switch documentChange.type {
                    case .added:
                        Task {
                            guard let user = await UserRepository.getUserData(userId: document.documentID) else { return }
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
                            PlayerDataStore.shared.userArray.remove(userId: player.playerUserId)
                            PlayerDataStore.shared.playerArray.remove(userId: player.playerUserId)
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
    
    static func observePlayersPropaty() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").addSnapshotListener { querySnapshot, error  in
            guard let documents = querySnapshot?.documents else { return }
            for document in documents {
                do {
                    let newPlayer = try document.data(as: Player.self)
                    guard var player = PlayerDataStore.shared.playerArray.first(where: { $0.playerUserId == document.documentID }) else { return }
                    player.point = newPlayer.point
                    player.isDecided = newPlayer.isDecided
                    DispatchQueue.main.async {
                        PlayerDataStore.shared.playerArray.append(noDuplicate: newPlayer)
                    }
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.playersPropaty] = listener
        }
    }
}
