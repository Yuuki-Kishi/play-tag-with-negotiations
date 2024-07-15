//
//  PlayerDataStore.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/30.
//

import Foundation
import OrderedCollections

class PlayerDataStore: ObservableObject {
    static let shared = PlayerDataStore()
    @Published var playingRoom: PlayTagRoom? = nil
    @Published var hostUser: User = User()
    @Published var hostPlayer: Player = Player()
    @Published var guestUserArray: [User] = []
    @Published var guestPlayerArray: [Player] = []
}

extension PlayerDataStore {
    func appendUser(user: User) {
        if !guestUserArray.contains(where: { $0.userId == user.userId }) {
            guestUserArray.append(user)
        }
    }
    
    func appendPlayer(player: Player) {
        if !guestPlayerArray.contains(where: { $0.userId == player.userId }) {
            guestPlayerArray.append(player)
        }
    }
}
