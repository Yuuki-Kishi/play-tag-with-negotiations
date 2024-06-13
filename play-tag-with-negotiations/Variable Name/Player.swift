//
//  Player.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import Foundation

class Player: Identifiable {
    var id = UUID()
    var playerId: String
    var playerName: String
    var onePhrase: String
    
    init(playerId: String, playerName: String, onePhrase: String) {
        self.playerId = playerId
        self.playerName = playerName
        self.onePhrase = onePhrase
    }
    
    init() {
        self.playerId = "unknoun"
        self.playerName = "unknownPlayer"
        self.onePhrase = "Who am I?"
    }
}
