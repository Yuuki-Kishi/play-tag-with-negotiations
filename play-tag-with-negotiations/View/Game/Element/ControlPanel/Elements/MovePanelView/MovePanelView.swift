//
//  MovePanel.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/12.
//

import SwiftUI

struct MovePanelView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        VStack {
            HStack {
                MovePanelViewButton(userDataStore: userDataStore, playerDataStore: playerDataStore, direction: .leftUp)
                MovePanelViewButton(userDataStore: userDataStore, playerDataStore: playerDataStore, direction: .up)
                MovePanelViewButton(userDataStore: userDataStore, playerDataStore: playerDataStore, direction: .rightUp)
            }
            HStack {
                MovePanelViewButton(userDataStore: userDataStore, playerDataStore: playerDataStore, direction: .left)
                MovePanelViewButton(userDataStore: userDataStore, playerDataStore: playerDataStore, direction: .stay)
                MovePanelViewButton(userDataStore: userDataStore, playerDataStore: playerDataStore, direction: .right)
            }
            HStack {
                MovePanelViewButton(userDataStore: userDataStore, playerDataStore: playerDataStore, direction: .leftDowm)
                MovePanelViewButton(userDataStore: userDataStore, playerDataStore: playerDataStore, direction: .dowm)
                MovePanelViewButton(userDataStore: userDataStore, playerDataStore: playerDataStore, direction: .rightDown)
            }
        }
    }
}

#Preview {
    MovePanelView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
