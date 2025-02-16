//
//  PlayerInfoView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/02/04.
//

import SwiftUI

struct PlayerInfoListView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        if playerDataStore.playerArray.isEmpty {
            Text("情報を見るプレイヤーを選択してください")
        } else {
            List($playerDataStore.selectedPlayers) { player in
                PlayerInfoListViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, player: player)
            }
        }
    }
}

#Preview {
    PlayerInfoListView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
