//
//  Fulfill.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/08.
//

import Foundation

class DealFulfill {
    static func fulfillDeal(deal: Deal) async {
        guard let negotiation = PlayerDataStore.shared.negotiationArray.first(where: { $0.negotiationId == deal.negotiationId }) else { return }
        switch negotiation.negotiationName {
        case .missOnce:
            await missOnce(deal: deal)
        case .unknown:
            break
        }
    }
    
    static func missOnce(deal: Deal) async {
        await PlayerRepository.catcher(userId: deal.clientUserId)
        await DealRepository.dealFulfill(deal: deal)
    }
}
