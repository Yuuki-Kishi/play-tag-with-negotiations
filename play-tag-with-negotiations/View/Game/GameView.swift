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
    @ObservedObject var pathDataStore: PathDataStore
    
    var body: some View {
        VStack {
            FieldMapView(userDataStore: userDataStore, playerDataStore: playerDataStore)
            Text(displayPhase())
            VStack {
                SelectionView(userDataStore: userDataStore, playerDataStore: playerDataStore)
                ControlPanelCoordination(userDataStore: userDataStore, playerDataStore: playerDataStore)
                Spacer(minLength: 20)
            }
            .frame(height: UIScreen.main.bounds.height * 0.35)
        }
        .navigationTitle(playerDataStore.playingRoom.playTagName)
        .background(Color(UIColor.systemGray6))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Menu {
                    Button(action: {
                        pathDataStore.navigatetionPath.append(.roomInfo)
                    }, label: {
                        Label("ルール", systemImage: "info.circle")
                    })
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            })
        }
        .navigationBarBackButtonHidden()
        .onAppear() {
            Task {
                let roomId = playerDataStore.playingRoom.roomId.uuidString
                ObserveToFirestore.observeRoomField(roomId: roomId)
                ObserveToFirestore.observeIsDecided()
                await ReadToFirestore.getPlayers(roomId: roomId)
            }
        }
    }
    func displayPhase() -> String {
        let phaseNow = String(playerDataStore.playingRoom.phaseNow)
        let phaseMax = String(playerDataStore.playingRoom.phaseMax)
        let text = phaseNow + "フェーズ / " + phaseMax + "フェーズ"
        return text
    }
}

#Preview {
    GameView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
