//
//  NegotiationPanel.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/12.
//

import SwiftUI

struct NegotiationPanelView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        List {
            ForEach(playerDataStore.guestUserArray, id: \.userId) { user in
                if user.userId != userDataStore.signInUser?.userId {
                    NegotiationPanelViewCell(user: user)
                }
            }
        }
    }
}

#Preview {
    NegotiationPanelView(userDataStore: UserDataStore.shared,  playerDataStore: PlayerDataStore.shared)
}
