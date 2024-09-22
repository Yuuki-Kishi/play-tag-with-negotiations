//
//  Proposal.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/07.
//

import Foundation

class Success {
    static func successDeal(deal: Deal) async {
        let negotiation = PlayerDataStore.shared.negotiationArray.negotiation(negotiationId: deal.negotiationId)
        switch negotiation.negotiationName {
        case .missOnce:
            await missOnce(deal: deal)
        case .unknown:
            break
        }
    }
    
    static func missOnce(deal: Deal) async {
        await DealUpdate.confiscatePoint(userId: deal.proposerUserId, howMany: 50)
        await DealUpdate.cannotCapturePlayer(userId: deal.proposerUserId)
        await DealUpdate.dealSuccess(deal: deal)
    }
}
