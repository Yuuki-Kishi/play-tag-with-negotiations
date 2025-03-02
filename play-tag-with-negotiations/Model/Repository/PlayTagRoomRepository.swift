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
    static func createPlayTagRoom() async {
        let playTagRoom = PlayerDataStore.shared.playingRoom
        let encoded = try! JSONEncoder().encode(playTagRoom)
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("PlayTagRooms").document(playTagRoom.roomId).setData(jsonObject)
            await PlayerRepository.enterRoom(roomId: playTagRoom.roomId, isHost: true)
        } catch {
            print(error)
        }
    }
    
    //    check
    static func isExists(roomId: String) async -> Bool {
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).getDocument()
            if document.exists { return true }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    static func isOverPlayerCount(roomId: String) async -> Bool {
        guard let playTagRoom = await getRoomData(roomId: roomId) else { return true }
        if playTagRoom.playerNumber < playTagRoom.chaserNumber + playTagRoom.fugitiveNumber { return false }
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
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["isPlaying": true])
        } catch {
            print(error)
        }
    }
    
    static func appointmentChaser() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let chaserNumber = PlayerDataStore.shared.playingRoom.chaserNumber
        let chasersId = PlayerDataStore.shared.playerArray.shuffled().prefix(chaserNumber).map { $0.playerUserId }
        for chaserId in chasersId {
            do {
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(chaserId).updateData(["isChaser": true])
            } catch {
                print(error)
            }
        }
    }
    
    static func moveToNextPhase() async {
        let phaseMax = PlayerDataStore.shared.playingRoom.phaseMax
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        if phaseNow < phaseMax {
            do {
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["phaseNow": phaseNow + 1])
            } catch {
                print(error)
            }
        } else {
            await gameFinished()
        }
    }
    
    static func gameFinished() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["isFinished": true])
        } catch {
            print(error)
        }
    }
    
    //    delete
    static func deleteRoom() async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).delete()
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).delete()
            try await Firestore.firestore().collection("Users").document(userId).updateData(["beingRoomId": FieldValue.delete()])
        } catch {
            print(error)
        }
    }
    
    
    
//    observe
    static func observeRoomField() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).addSnapshotListener { DocumentSnapshot, error in
            do {
                guard let playingRoom = try DocumentSnapshot?.data(as: PlayTagRoom.self) else { return }
                if PlayerDataStore.shared.playingRoom.phaseNow < playingRoom.phaseNow {
                    Task {
                        await DealRepository.isFulfilled(phaseNow: playingRoom.phaseNow)
                        await PlayerRepository.getAlivePlayers(phaseNow: playingRoom.phaseNow)
                    }
                    TimerDataStore.shared.setTimer(limit: 60)
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
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").whereField("isDecided", isEqualTo: true).addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else { return }
            if PlayerDataStore.shared.playingRoom.playerNumber <= documents.count {
                Task { await moveToNextPhase() }
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
                do {
                    let publicRoom = try document.data(as: PlayTagRoom.self)
                    DispatchQueue.main.async {
                        RoomDataStore.shared.publicRoomsArray.append(publicRoom)
                    }
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.publicRooms] = listener
        }
    }
}
