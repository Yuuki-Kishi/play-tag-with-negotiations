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
    @Published var hostUser: User = User()
    @Published var hostPlayer: Player = Player()
    @Published var guestUserArray: [User] = []
    @Published var guestPlayerArray: [Player] = []
    @Published var playerUserArray: [User] = []
    @Published var playerPlayerArray: [Player] = []
}
