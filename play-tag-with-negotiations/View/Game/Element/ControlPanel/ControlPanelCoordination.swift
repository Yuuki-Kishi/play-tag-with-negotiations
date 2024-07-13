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
    
    var body: some View {
        switch userDataStore.displayControlPanel {
        case .movement:
            MovePanelView(userDataStore: userDataStore, playerDataStore: playerDataStore)
        case .negotiation:
            NegotiationPanelView(userDataStore: userDataStore, playerDataStore: playerDataStore)
        }
    }
}

#Preview {
    ControlPanelCoordination(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
