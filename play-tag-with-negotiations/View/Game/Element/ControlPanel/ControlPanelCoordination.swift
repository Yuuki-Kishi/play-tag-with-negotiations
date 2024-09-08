//
//  ControlPanelCoordination.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/12.
//

import SwiftUI

struct ControlPanelCoordination: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @ObservedObject var pathDataStore: PathDataStore
    
    var body: some View {
        switch userDataStore.displayControlPanel {
        case .movement:
            MovePanelView(userDataStore: userDataStore, playerDataStore: playerDataStore)
        case .deal(.negotiation):
            DealTargetPanelView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
        case .deal(.target):
            DealPanelView(playerDataStore: playerDataStore)
                .transition(.move(edge: .trailing))
        }
    }
}

#Preview {
    ControlPanelCoordination(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
