//
//  DealCreate.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/05.
//

import Foundation

class DealCreate {
    static func createDeal(targetUserId: String, negotiation: Negotiation, consideration: Int) -> Deal {
        switch negotiation.negotiationName {
        case .missOnce:
            return missOnce(targetUserId: targetUserId, negotiation: negotiation, consideration: consideration)
        case .freezeOnce:
            return freezeOnce(targetUserId: targetUserId, negotiation: negotiation, consideration: consideration)
        case .changePosition:
            return changePosition(targetUserId: targetUserId, negotiation: negotiation, consideration: consideration)
        case .unknown:
            return Deal()
        }
    }
    
    static func missOnce(targetUserId: String, negotiation: Negotiation, consideration: Int) -> Deal {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return Deal() }
        let deal = Deal(negotiationId: negotiation.negotiationId, proposerUserId: myUserId, clientUserId: targetUserId, period: 2, consideration: consideration)
        return deal
    }
    
    static func freezeOnce(targetUserId: String, negotiation: Negotiation, consideration: Int) -> Deal {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return Deal() }
        let deal = Deal(negotiationId: negotiation.negotiationId, proposerUserId: myUserId, clientUserId: targetUserId, period: 2, consideration: consideration)
        return deal
    }
    
    static func changePosition(targetUserId: String, negotiation: Negotiation, consideration: Int) -> Deal {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return Deal() }
        let deal = Deal(negotiationId: negotiation.negotiationId, proposerUserId: myUserId, clientUserId: targetUserId, period: 2, consideration: consideration)
        return deal
    }
}
