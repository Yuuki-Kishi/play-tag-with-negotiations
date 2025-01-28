//
//  NegotiationPanel.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/12.
//

import SwiftUI

struct DealClientPanelView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        List(playerDataStore.playerArray.users) { user in
            if user.userId != userDataStore.signInUser?.userId {
                DealClientPanelViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, user: user)
            }
        }
    }
}

#Preview {
    DealClientPanelView(userDataStore: UserDataStore.shared,  playerDataStore: PlayerDataStore.shared)
}
