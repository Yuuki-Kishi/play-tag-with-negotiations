//
//  Proposal.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/07.
//

import Foundation

class DealSuccess {
    static func successDeal(deal: Deal) async {
        guard let negotiation = PlayerDataStore.shared.negotiationArray.first(where: { $0.negotiationId == deal.negotiationId }) else { return }
        switch negotiation.negotiationName {
        case .missOnce:
            await missOnce(deal: deal)
        case .unknown:
            break
        }
    }
    
    static func missOnce(deal: Deal) async {
        await PlayerRepository.confiscatePoint(userId: deal.proposerUserId, howMany: deal.consideration)
        await PlayerRepository.grantPoint(userId: deal.clientUserId, howMany: deal.consideration)
        await PlayerRepository.nonCatcher(userId: deal.clientUserId)
        await DealRepository.dealSuccess(deal: deal)
    }
}
