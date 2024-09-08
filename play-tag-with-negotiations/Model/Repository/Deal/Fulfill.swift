//
//  Proposal.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/07.
//

import Foundation

class Fulfill {
    static func fulfillDeal(deal: Deal) async {
        switch deal.negotiation.negotiationName {
        case .missOnce:
            await missOnce(deal: deal)
        case .unknown:
            break
        }
    }
    
    static func missOnce(deal: Deal) async {
        await Update.confiscatePoint(userId: deal.targetUserId, howMany: 50)
        await DealUpdate.cannotCapturePlayer()
        await DealUpdate.dealSuccess(deal: deal)
    }
}
