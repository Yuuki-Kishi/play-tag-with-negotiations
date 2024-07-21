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
        List($playerDataStore.playerUserArray) { user in
            if user.wrappedValue.userId != userDataStore.signInUser?.userId {
                NegotiationPanelViewCell(user: user)
            }
        }
    }
}

#Preview {
    NegotiationPanelView(userDataStore: UserDataStore.shared,  playerDataStore: PlayerDataStore.shared)
}
