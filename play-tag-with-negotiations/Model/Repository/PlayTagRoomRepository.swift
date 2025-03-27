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
    static func createAndEnterPlayTagRoom() async {
        var playTagRoom = PlayerDataStore.shared.playingRoom
        playTagRoom.playerNumber += 1
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let player = Player(playerUserId: userId, isHost: true)
        let encodedPlayTagRoom = try! JSONEncoder().encode(playTagRoom)
        let encodedPlayer = try! JSONEncoder().encode(player)
        do {
            guard let jsonObjectPlayTagRoom = try JSONSerialization.jsonObject(with: encodedPlayTagRoom, options: []) as? [String: Any] else { return }
            guard let jsonObjectPlayer = try JSONSerialization.jsonObject(with: encodedPlayer, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("PlayTagRooms").document(playTagRoom.roomId).setData(jsonObjectPlayTagRoom)
            try await Firestore.firestore().collection("PlayTagRooms").document(playTagRoom.roomId).collection("Players").document(userId).setData(jsonObjectPlayer)
        } catch {
            print(error)
        }
        await UserRepository.addPlayedRoomIds(roomId: playTagRoom.roomId)
    }
    
    //    check
    static func isExists(roomId: String) async -> Bool {
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).getDocument()
            return document.exists
        } catch {
            print(error)
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
        } catch {
            print(error)
        }
        await UserRepository.removePlayedRoomIds(roomId: roomId)
    }
    
    //    observe
    static func observeRoomFieldAndPhaseNow() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).addSnapshotListener { DocumentSnapshot, error in
            do {
                guard let playingRoom = try DocumentSnapshot?.data(as: PlayTagRoom.self) else { return }
                if PlayerDataStore.shared.playingRoom.phaseNow < playingRoom.phaseNow {
                    Task { await DealRepository.isFulfilled(phaseNow: playingRoom.phaseNow) }
                    if !PlayerDataStore.shared.playerArray.me.isCaptured {
                        Task { await PlayerRepository.isDecidedToFalse() }
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
            UserDataStore.shared.listeners[UserDataStore.listenerType.phaseNow] = listener
        }
    }
    
    static func observeRoomField() {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).addSnapshotListener { DocumentSnapshot, error in
            guard let ducument = DocumentSnapshot else { return }
            if ducument.exists {
                do {
                    guard let playingRoom = try DocumentSnapshot?.data(as: PlayTagRoom.self) else { return }
                    DispatchQueue.main.async {
                        PlayerDataStore.shared.playingRoom = playingRoom
                    }
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.roomField] = listener
        }
    }
    
    static func observePublicRooms() {
        let listener = Firestore.firestore().collection("PlayTagRooms").whereField("isPublic", isEqualTo: true).addSnapshotListener { QuerySnapshot, error in
            guard let documentChanges = QuerySnapshot?.documentChanges else { return }
            for documentChange in documentChanges {
                let document = documentChange.document
                do {
                    let publicRoom = try document.data(as: PlayTagRoom.self)
                    switch documentChange.type {
                    case .added:
                        DispatchQueue.main.async {
                            RoomDataStore.shared.publicRoomsArray.append(noDuplicate: publicRoom)
                        }
                    case .modified:
                        DispatchQueue.main.async {
                            RoomDataStore.shared.publicRoomsArray.append(noDuplicate: publicRoom)
                        }
                    case .removed:
                        DispatchQueue.main.async {
                            RoomDataStore.shared.publicRoomsArray.remove(playTagRoom: publicRoom)
                        }
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
