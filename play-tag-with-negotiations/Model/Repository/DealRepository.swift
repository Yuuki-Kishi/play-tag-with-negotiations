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
    
//    check
    static func checkDeals(phaseNow: Int) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let myDeals = PlayerDataStore.shared.dealArray.filter { $0.proposerUserId == myUserId && $0.condition != .fulfilled }
        for myDeal in myDeals {
            if myDeal.expiredPhase <= phaseNow {
                await Fulfill.fulfillDeal(deal: myDeal)
            }
        }
    }
    
//    get
    
//    update
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
    
//    delete
    
//    observe
    static func observeDeals() {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let listener = Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Deals").whereField("condition", isNotEqualTo: "fulfilled").addSnapshotListener { QuerySnapshot, error in
            guard let documentChanges = QuerySnapshot?.documentChanges else { return }
            for documentChange in documentChanges {
                do {
                    let document = documentChange.document
                    let deal = try document.data(as: Deal.self)
                    if deal.proposerUserId == myUserId || deal.targetUserId == myUserId {
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
                                PlayerDataStore.shared.dealArray.delete(deal: deal)
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
    
//    propose
    static func proposeDeal(negotiation: Negotiation) async {
        switch negotiation.negotiationName {
        case .missOnce:
            await missOnce(negotiation: negotiation)
        case .unknown:
            break
        }
    }
    
    static func missOnce(negotiation: Negotiation) async {
        await DealCreate.proposeDeal(negotiationId: negotiation.negotiationId.uuidString)
    }
    
//    success
    static func successDeal(deal: Deal) async {
        guard let negotiation = PlayerDataStore.shared.negotiationArray.first(where: { $0.negotiationId.uuidString == deal.negotiationId }) else { return }
        switch negotiation.negotiationName {
        case .missOnce:
            await missOnce(deal: deal)
        case .unknown:
            break
        }
    }
    
    static func missOnce(deal: Deal) async {
        await DealUpdate.confiscatePoint(userId: deal.proposerUserId, howMany: 50)
        await Update.grantPoint(userId: deal.targetUserId, howMany: 50)
        await DealUpdate.cannotCapturePlayer(userId: deal.proposerUserId)
        await DealUpdate.dealSuccess(deal: deal)
    }
    
//    fulfill
//    static func fulfillDeal(deal: Deal) async {
//        guard let negotiation = PlayerDataStore.shared.negotiationArray.first(where: { $0.negotiationId.uuidString == deal.negotiationId }) else { return }
//        switch negotiation.negotiationName {
//        case .missOnce:
//            await missOnce(deal: deal)
//        case .unknown:
//            break
//        }
//    }
//    
//    static func missOnce(deal: Deal) async {
//        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
//        if myUserId == deal.proposerUserId {
//            await DealUpdate.fulfillDeal(deal: deal)
//            await DealUpdate.canCapturePlayer(userId: deal.proposerUserId)
//        }
//    }
}
