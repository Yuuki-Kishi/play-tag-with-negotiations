//
//  PlayTagRoomRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/12/09.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class PlayTagRoomRepository {
    //    create
//    static func createPlayTagRoom(playTagRoom: PlayTagRoom) async {
//        let encoded = try! JSONEncoder().encode(playTagRoom)
//        let roomId = playTagRoom.roomId.uuidString
//        do {
//            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
//            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).setData(jsonObject)
//            await enterRoom(roomId: roomId, isHost: true)
//        } catch {
//            print(error)
//        }
//    }
    
    //    check
    static func checkIsThereRoom(roomId: String) async -> Bool {
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).getDocument()
            if document.exists { return true }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    static func checkNotOverPlayerCount(roomId: String) async -> Bool {
        do {
            let playersCount = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").getDocuments().count
            guard let playTagRoom = await Get.getRoomData(roomId: roomId) else { return false }
            let limit = playTagRoom.chaserNumber + playTagRoom.fugitiveNumber
            if playersCount < limit { return true }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    //    get
    static func getRoomData(roomId: String) async -> PlayTagRoom? {
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).getDocument()
            let playTagRoom = try document.data(as: PlayTagRoom.self)
            return playTagRoom
        } catch {
            print(error)
        }
        return nil
    }
    
    //    update
    static func gameStart() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let playerNumber = PlayerDataStore.shared.playerArray.count
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["playerNumber": playerNumber, "isPlaying": true])
        } catch {
            print(error)
        }
    }
    
    static func appointmentChaser() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let chaserNumber = PlayerDataStore.shared.playingRoom.chaserNumber
        let chasers = PlayerDataStore.shared.playerArray.shuffled().prefix(chaserNumber)
        for chaser in chasers {
            do {
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(chaser.playerUserId).updateData(["isChaser": true, "isCanCapture": false])
            } catch {
                print(error)
            }
        }
    }
    
    static func moveToNextPhase() async {
        let phaseMax = PlayerDataStore.shared.playingRoom.phaseMax
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        if phaseNow < phaseMax {
            do {
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["phaseNow": phaseNow + 1])
            } catch {
                print(error)
            }
        } else {
            await gameEnd()
        }
    }
    
    static func gameEnd() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["isEnd": true])
        } catch {
            print(error)
        }
    }
    
    //    delete
    static func deleteRoom(roomId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).delete()
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).delete()
            try await Firestore.firestore().collection("Users").document(userId).updateData(["beingRoomId": FieldValue.delete()])
        } catch {
            print(error)
        }
    }
    
    static func endGame() async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).updateData(["beingRoomId": FieldValue.delete()])
        } catch {
            print(error)
        }
    }
    
//    observe
    static func observeRoomField() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).addSnapshotListener { DocumentSnapshot, error in
            do {
                guard let playingRoom = try DocumentSnapshot?.data(as: PlayTagRoom.self) else { return }
                if PlayerDataStore.shared.playingRoom.phaseNow < playingRoom.phaseNow {
                    Task {
                        await Check.checkDeals(phaseNow: playingRoom.phaseNow)
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
    
    static func observeIsDecided() {
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
}
