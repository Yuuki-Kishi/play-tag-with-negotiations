//
//  Fulfill.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/08.
//

import Foundation

class Fulfill {
    static func fulfillDeal(deal: Deal) async {
        let negotiation = PlayerDataStore.shared.negotiationArray.negotiation(negotiationId: deal.negotiationId)
        switch negotiation.negotiationName {
        case .missOnce:
            await missOnce(deal: deal)
        case .unknown:
            break
        }
    }
    
    static func missOnce(deal: Deal) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        if myUserId == deal.proposerUserId {
            await DealUpdate.fulfillDeal(deal: deal)
            await DealUpdate.canCapturePlayer(userId: deal.proposerUserId)
        }
    }
}
