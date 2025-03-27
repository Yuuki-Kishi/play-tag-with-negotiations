//
//  PlayerDataStore.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/30.
//

import Foundation

class PlayerDataStore: ObservableObject {
    static let shared = PlayerDataStore()
    @Published var playingRoom: PlayTagRoom = PlayTagRoom()
    @Published var userArray: [User] = []
    @Published var playerArray: [Player] = []
    @Published var selectedPlayers: [Player] = []
    @Published var selectedPlayer: Player = Player()
    @Published var negotiationArray: [Negotiation] = []
    @Published var dealArray: [Deal] = []
    @Published var countDownTimer: Int = 60
    
    func cleanUp() {
        self.playingRoom = PlayTagRoom()
        self.userArray.removeAll()
        self.playerArray.removeAll()
        self.selectedPlayers.removeAll()
        self.selectedPlayer = Player()
        self.negotiationArray.removeAll()
        self.dealArray.removeAll()
    }
}
