//
//  NegotiationPanel.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/12.
//

import SwiftUI

struct DealClientListView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        List(playerDataStore.selectedPlayers) { player in
            if player.playerUserId != userDataStore.signInUser?.userId {
                DealClientListViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, player: Binding(get: { player  }, set: {_ in}))
            }
        }
    }
}

#Preview {
    DealClientListView(userDataStore: UserDataStore.shared,  playerDataStore: PlayerDataStore.shared)
}
