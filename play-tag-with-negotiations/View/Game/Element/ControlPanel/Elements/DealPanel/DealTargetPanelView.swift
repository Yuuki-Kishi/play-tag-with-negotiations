//
//  NegotiationPanel.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/12.
//

import SwiftUI

struct DealTargetPanelView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @ObservedObject var pathDataStore: PathDataStore
    
    var body: some View {
        List(playerDataStore.playerArray.users) { user in
            if user.userId != userDataStore.signInUser?.userId {
                DealTargetPanelViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, user: user)
            }
        }
    }
}

#Preview {
    DealTargetPanelView(userDataStore: UserDataStore.shared,  playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
