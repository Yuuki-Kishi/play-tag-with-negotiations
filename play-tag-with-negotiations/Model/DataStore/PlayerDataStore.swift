//
//  PlayerDataStore.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/30.
//

import Foundation

class PlayerDataStore: ObservableObject {
    static let shared = PlayerDataStore()
    @Published var playingRoom: PlayTagRoom? = nil
    @Published var hostUser: User = User()
    @Published var hostPlayer: Player = Player()
    @Published var userArray: [User] = []
    @Published var playerArray: [Player] = []
}
