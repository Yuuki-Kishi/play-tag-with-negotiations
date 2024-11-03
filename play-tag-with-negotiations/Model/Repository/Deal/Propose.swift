//
//  Propose.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/10/26.
//
import Foundation

class Propose {
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
}
