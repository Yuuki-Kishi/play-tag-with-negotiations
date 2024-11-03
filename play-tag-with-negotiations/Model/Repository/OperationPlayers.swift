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
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        var aliveFugitives: [Player] = []
        for fugitive in fugitives {
            if !fugitive.isCanCapture {
                aliveFugitives.append(noDuplicate: fugitive)
                continue
            }
            var chasersPosition: [PlayerPosition] = []
            for chaser in chasers {
                guard let chaserPosition = chaser.move.first(where: { $0.phase == phaseNow }) else { return [] }
                chasersPosition.append(chaserPosition)
            }
            let isContain = chasersPosition.contains(where: { $0 == fugitive.move.first { $0.phase == phaseNow } })
            if isContain { continue }
            aliveFugitives.append(noDuplicate: fugitive)
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
