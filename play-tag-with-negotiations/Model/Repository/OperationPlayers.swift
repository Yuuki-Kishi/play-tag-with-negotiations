//
//  OperationPlayers.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/17.
//

import Foundation

class OperationPlayers {
    static func getChasers(players: [Player]) -> [Player] {
        let chasers = players.filter { $0.isChaser }
        return chasers
    }
    
    static func getFugitives(players: [Player]) -> [Player] {
        let fugitives = players.filter { !$0.isChaser }
        return fugitives
    }
    
    static func getAliveFugitives(players: [Player]) -> [Player] {
        let chasers = getChasers(players: players)
        let fugitives = getFugitives(players: players)
        var aliveFugitives: [Player] = []
        for fugitive in fugitives {
            let isContain = chasers.contains(where: { $0.move.last == fugitive.move.last })
            if !isContain {
                aliveFugitives.append(noDuplicate: fugitive)
            }
        }
        return aliveFugitives
    }
    
    static func getAlivePlayers(players: [Player]) -> [Player] {
        let chasers = getChasers(players: players)
        let aliveFugitives = getAliveFugitives(players: players)
        return chasers + aliveFugitives
    }
    
    static func isAlive(players: [Player]) -> Bool {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return false }
        let alivePlayers = getAlivePlayers(players: players)
        let isAlive = alivePlayers.contains(where: { $0.playerUserId == myUserId })
        return isAlive
    }
}
