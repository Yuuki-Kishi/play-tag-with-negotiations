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
    
    static func judgeIsAlive(player: Player, players: [Player]) async -> Player {
        var judgelayer = player
        if player.isChaser { return judgelayer }
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        let chasers = players.filter { $0.isChaser }
//        print("player:", player.playerUserId)
        guard let fugitivePosition = player.move.first(where: { $0.phase == phaseNow }) else { return player }
//        print("fugitivePosition:", fugitivePosition)
        for chaser in chasers {
            guard let chaserPosition = chaser.move.first(where: { $0.phase == phaseNow }) else { continue }
//            print("chaserPosition:", chaserPosition)
            if chaserPosition == fugitivePosition {
                let isContain = player.catchers.contains(chaser.playerUserId)
                if isContain {
                    judgelayer.isCaptured = true
                    if judgelayer.isMe {
                        await PlayerRepository.wasCaptured()
                    }
                    break
                }
            }
        }
        return judgelayer
    }
    
//    update
    static func playerUpToHost() async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        DispatchQueue.main.async {
            PlayerDataStore.shared.playerArray.remove(userId: myUserId)
        }
        guard let nextHostUserId = PlayerDataStore.shared.playerArray.guests.randomElement()?.playerUserId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(myUserId).updateData(["isHost": false])
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(nextHostUserId).updateData(["isHost": true])
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["hostUserId": nextHostUserId])
        } catch {
            print(error)
        }
    }
    
    static func isDecidedToFalse() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isDecided": false])
        } catch {
            print(error)
        }
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
    
    static func wasReleaced() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isDecided": false, "isCaptured": false])
        } catch {
            print(error)
        }
    }
    
    static func stopPlaying() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isDecided": true, "isPlaying": false])
        } catch {
            print(error)
        }
    }
    
    static func continuePlaying() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isPlaying": true])
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
    static func exitRoom(roomId: String = PlayerDataStore.shared.playingRoom.roomId) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let playerNumber = PlayerDataStore.shared.playingRoom.playerNumber - 1
        do {
            try await Firestore.firestore().collection("Users").document(userId).updateData(["beingRoomId": FieldValue.delete()])
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).delete()
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["playerNumber": playerNumber])
        } catch {
            print(error)
        }
    }
    
    static func hostExitRoom() async {
        await playerUpToHost()
        await exitRoom()
    }
    
//    observe
    static func observePlayers() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            var players: [Player] = []
            for document in documents {
                do {
                    let player = try document.data(as: Player.self)
                    players.append(noDuplicate: player)
                } catch {
                    print(error)
                }
            }
            guard let documentChanges = querySnapshot?.documentChanges else { return }
            Task {
                for documentChange in documentChanges {
                    do {
                        let player = try documentChange.document.data(as: Player.self)
                        let judgedPlayer = await judgeIsAlive(player: player, players: players)
//                        print("judgedPlayer:", judgedPlayer)
                        switch documentChange.type {
                        case .added:
                            DispatchQueue.main.async {
                                PlayerDataStore.shared.playerArray.append(noDuplicate: judgedPlayer)
                            }
                        case .modified:
                            DispatchQueue.main.async {
                                PlayerDataStore.shared.playerArray.append(noDuplicate: judgedPlayer)
                            }
                        case .removed:
                            DispatchQueue.main.async {
                                PlayerDataStore.shared.playerArray.remove(userId: judgedPlayer.playerUserId)
                            }
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
    
    static func observeGame() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").whereField("isCaptured", isEqualTo: false).addSnapshotListener { querySnapshot, error in
            var alivePlayers: [Player] = []
            guard let documents = querySnapshot?.documents else { return }
            for document in documents {
                do {
                    let player = try document.data(as: Player.self)
                    alivePlayers.append(noDuplicate: player)
                } catch {
                    print(error)
                }
            }
            if alivePlayers.count <= 1 || alivePlayers.filter ({ !$0.isChaser }).isEmpty {
                if PlayerDataStore.shared.playerArray.me.isHost {
                    Task { await PlayTagRoomRepository.gameFinished() }
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.game] = listener
        }
    }
}
