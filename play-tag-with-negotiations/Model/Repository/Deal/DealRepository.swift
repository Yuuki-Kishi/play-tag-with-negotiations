//
//  DealRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/12/09.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DealRepository {
//    create
    static func proposeDeal(targetUserId: String, negotiation: Negotiation, point: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        guard let consideration = Int(point) else { return }
        if PlayerDataStore.shared.playerArray.me.point < consideration { return }
        await PlayerRepository.confiscatePoint(userId: myUserId, howMany: consideration)
        let deal = DealCreate.createDeal(targetUserId: targetUserId, negotiation: negotiation, consideration: consideration)
        let encoded = try! JSONEncoder().encode(deal)
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").document(deal.dealId).setData(jsonObject)
        } catch {
            print(error)
        }
    }
    
//    check
    static func isFulfilled(phaseNow: Int) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let myDeals = PlayerDataStore.shared.dealArray.filter { $0.proposerUserId == myUserId && $0.condition != .fulfilled }
        for myDeal in myDeals {
            if myDeal.expiredPhase <= phaseNow {
                await DealFulfill.fulfillDeal(deal: myDeal)
            }
        }
    }
    
//    get
    
//    update
    static func dealSuccess(deal: Deal) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        let expiredPhase = phaseNow + deal.period
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").document(deal.dealId).updateData(["successPhase": phaseNow, "expiredPhase": expiredPhase, "condition": Deal.dealCondition.success.rawValue])
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(deal.proposerUserId).updateData(["deals": FieldValue.arrayUnion([deal.dealId])])
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(deal.clientUserId).updateData(["deals": FieldValue.arrayUnion([deal.dealId])])
        } catch {
            print(error)
        }
    }
    
    static func dealRefuse(deal: Deal) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").document(deal.dealId).updateData(["condition": Deal.dealCondition.failure.rawValue])
        } catch {
            print(error)
        }
    }
    
    static func dealFulfill(deal: Deal) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").document(deal.dealId)
                .updateData(["condition": Deal.dealCondition.fulfilled.rawValue])
        } catch {
            print(error)
        }
    }
    
//    delete
    
//    observe
    static func observeDeals() {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").addSnapshotListener { QuerySnapshot, error in
            guard let documentChanges = QuerySnapshot?.documentChanges else { return }
            for documentChange in documentChanges {
                do {
                    let document = documentChange.document
                    let deal = try document.data(as: Deal.self)
                    if deal.proposerUserId == myUserId || deal.clientUserId == myUserId {
                        switch documentChange.type {
                        case .added:
                            DispatchQueue.main.async {
                                PlayerDataStore.shared.dealArray.append(noDuplicate: deal)
                            }
                        case .modified:
                            DispatchQueue.main.async {
                                PlayerDataStore.shared.dealArray.append(noDuplicate: deal)
                            }
                        case .removed:
                            DispatchQueue.main.async {
                                PlayerDataStore.shared.dealArray.remove(deal: deal)
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.deal] = listener
        }
    }
}
