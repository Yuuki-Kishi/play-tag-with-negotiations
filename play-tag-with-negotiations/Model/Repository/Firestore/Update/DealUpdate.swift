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
    
    static func fulfillDeal(deal: Deal) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").document(deal.dealId.uuidString)
                .updateData(["condition": Deal.dealCondition.fulfilled.rawValue])
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
        DispatchQueue.main.async {
            guard var proposer = PlayerDataStore.shared.playerArray.first(where: { $0.playerUserId == userId }) else { return }
            proposer.point = nowPoint - howMany
            PlayerDataStore.shared.playerArray.append(noDuplicate: proposer)
            print("別途参照", PlayerDataStore.shared.playerArray.me.point)
        }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["point": nowPoint - howMany])
        } catch {
            print(error)
        }
    }
    
    static func cannotCapturePlayer(userId: String) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isCanCapture": false])
        } catch {
            print(error)
        }
    }
    
    static func canCapturePlayer(userId: String) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isCanCapture": true])
        } catch {
            print(error)
        }
    }
}
