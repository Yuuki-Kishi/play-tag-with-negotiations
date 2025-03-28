//
//  PlayedRoomRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/28.
//

import Foundation
import FirebaseFirestore

class PlayedRoomRepository {
    //get
    static func getPlayedRooms() async {
        guard let playedRoomIds = UserDataStore.shared.signInUser?.playedRoomIds.map({ $0.roomId }) else { return }
        for playedRoomId in playedRoomIds {
            do {
                let document = try await Firestore.firestore().collection("PlayTagRooms").document(playedRoomId).getDocument()
                let playTagRoom = try document.data(as: PlayTagRoom.self)
                let documents = try await Firestore.firestore().collection("PlayTagRooms").document(playTagRoom.roomId).collection("Players").getDocuments().documents
                var players: [Player] = []
                for document in documents {
                    let player = try document.data(as: Player.self)
                    players.append(noDuplicate: player)
                }
                let playedRoom = PlayedRoom(playTagRoom: playTagRoom, players: players)
                DispatchQueue.main.async {
                    UserDataStore.shared.fightRecordArray.append(noDuplicate: playedRoom)
                }
            } catch {
                print(error)
            }
        }
    }
    
    //delete
    static func deletePlayedRooms() async {
        await PlayedRoomIdRepository.deletePlayedRoomIds()
        DispatchQueue.main.async {
            UserDataStore.shared.fightRecordArray.removeAll()
        }
    }
}
