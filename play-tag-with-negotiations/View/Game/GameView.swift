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
    
    @State private var isShowWasCapturedAlert = false
    
    var body: some View {
        VStack {
            FieldMapView(userDataStore: userDataStore, playerDataStore: playerDataStore)
            Text(displayPhase())
            VStack {
                SelectionView(userDataStore: userDataStore, playerDataStore: playerDataStore)
                ControlPanelCoordination(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
                    .frame(height: UIScreen.main.bounds.height * 0.25)
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
        .onChange(of: playerDataStore.playingRoom.isEnd) {
            pathDataStore.navigatetionPath.append(.result)
        }
        .navigationBarBackButtonHidden()
        .onAppear() {
            Task {
                Observe.observeRoomField()
                Observe.observeIsDecided()
                Observe.observeMyIsDecided()
                await Get.getAlivePlayers()
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
