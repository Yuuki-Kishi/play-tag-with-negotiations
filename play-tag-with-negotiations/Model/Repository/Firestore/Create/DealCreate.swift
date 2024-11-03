//
//  Propose.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/10/26.
//
import Foundation
import FirebaseCore
import FirebaseFirestore

class DealCreate {
    static func proposeDeal(negotiationId: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let targetUserId = PlayerDataStore.shared.dealTarget.playerUserId
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        let deal = Deal(negotiationId: negotiationId, proposerUserId: myUserId, targetUserId: targetUserId, expiredPhase: phaseNow + 2)
        let encoded = try! JSONEncoder().encode(deal)
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").document(deal.dealId.uuidString).setData(jsonObject)
        } catch {
            print(error)
        }
    }
}
