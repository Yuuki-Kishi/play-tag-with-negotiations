//
//  DealUpdate.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/08.
//

import Foundation
import FirebaseFirestore

class DealUpdate {
    static func dealSuccess(deal: Deal) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").document(deal.dealId.uuidString).updateData(["condition": Deal.dealCondition.success.rawValue])
        } catch {
            print(error)
        }
    }
    
    static func refuseDeal(deal: Deal) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").document(deal.dealId.uuidString).updateData(["condition": Deal.dealCondition.failure.rawValue])
        } catch {
            print(error)
        }
    }
    
    static func cannotCapturePlayer() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isCanCapture": false])
        } catch {
            print(error)
        }
    }
}
