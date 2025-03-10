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
        case .freezeOnce:
            await freezeOnce(deal: deal)
        case .changePosition:
            await changePosition(deal: deal)
        case .unknown:
            break
        }
    }
    
    static func missOnce(deal: Deal) async {
        await PlayerRepository.grantPoint(userId: deal.clientUserId, howMany: deal.consideration)
        await PlayerRepository.nonCatcher(userId: deal.proposerUserId)
        await DealRepository.dealSuccess(deal: deal)
    }
    
    static func freezeOnce(deal: Deal) async {
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        guard let client = PlayerDataStore.shared.playerArray.first(where: { $0.playerUserId == deal.clientUserId }) else { return }
        guard let positioin = client.move.first(where: { $0.phase == phaseNow }) else { return }
        await PlayerRepository.grantPoint(userId: deal.clientUserId, howMany: deal.consideration)
        await PlayerPositionRepository.updatePosition(phase: phaseNow + 1, userId: deal.clientUserId, x: positioin.x, y: positioin.y)
        await DealRepository.dealSuccess(deal: deal)
    }
    
    static func changePosition(deal: Deal) async {
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        guard let proposer = PlayerDataStore.shared.playerArray.first(where: { $0.playerUserId == deal.proposerUserId }) else { return }
        guard let proposerPosition = proposer.move.first(where: { $0.phase == phaseNow }) else { return }
        guard let client = PlayerDataStore.shared.playerArray.first(where: { $0.playerUserId == deal.clientUserId }) else { return }
        guard let clientPositioin = client.move.first(where: { $0.phase == phaseNow }) else { return }
        await PlayerRepository.grantPoint(userId: deal.clientUserId, howMany: deal.consideration)
        await PlayerPositionRepository.updatePosition(phase: phaseNow + 1, userId: deal.proposerUserId, x: clientPositioin.x, y: clientPositioin.y)
        await PlayerPositionRepository.updatePosition(phase: phaseNow + 1, userId: deal.clientUserId, x: proposerPosition.x, y: proposerPosition.y)
        await DealRepository.dealSuccess(deal: deal)
    }
}
