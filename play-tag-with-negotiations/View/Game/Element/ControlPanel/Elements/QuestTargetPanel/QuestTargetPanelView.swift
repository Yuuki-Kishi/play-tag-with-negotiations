//
//  QuestPanelView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/14.
//

import SwiftUI

struct QuestTargetPanelView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        List(playerDataStore.playerArray.users) { user in
            if user.userId != userDataStore.signInUser?.userId {
                QuestTargetPanelVIewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, user: user)
            }
        }
    }
}

#Preview {
    QuestTargetPanelView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
