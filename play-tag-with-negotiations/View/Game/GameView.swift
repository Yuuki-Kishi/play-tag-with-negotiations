//
//  Game.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        VStack {
            FieldMapView(userDataStore: userDataStore, playerDataStore: playerDataStore)
                .frame(height: UIScreen.main.bounds.height * 0.5)
            VStack {
                SelectionView(userDataStore: userDataStore, playerDataStore: playerDataStore)
                    .padding(.top, 20)
                Spacer()
                switch userDataStore.displayControlPanel {
                case .movement:
                    ControlPanelCoordination(userDataStore: userDataStore, playerDataStore: playerDataStore)
                case .negotiation:
                    NegotiationPanelView(userDataStore: userDataStore, playerDataStore: playerDataStore)
                }
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height * 0.5)
        }
    }
}

#Preview {
    GameView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
