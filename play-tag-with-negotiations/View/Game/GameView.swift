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
            HStack {
                Text(displayPhase())
                    .padding(.leading)
                Spacer()
                Text(point())
                    .padding(.trailing)
            }
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
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            Task {
                Observe.observeIsDecided()
                Observe.observeMyIsDecided()
                Observe.observeDeals()
                Observe.observeMyPoint()
                await Get.getAlivePlayers()
            }
        }
        .onDisappear() {
            userDataStore.listeners[.roomField]?.remove()
            userDataStore.listeners.removeValue(forKey: .roomField)
            userDataStore.listeners[.isDecided]?.remove()
            userDataStore.listeners.removeValue(forKey: .isDecided)
            userDataStore.listeners[.myIsDecided]?.remove()
            userDataStore.listeners.removeValue(forKey: .myIsDecided)
        }
    }
    func displayPhase() -> String {
        let phaseNow = String(playerDataStore.playingRoom.phaseNow)
        let phaseMax = String(playerDataStore.playingRoom.phaseMax)
        let text = phaseNow + "フェーズ / " + phaseMax + "フェーズ"
        return text
    }
    func point() -> String {
        let point = playerDataStore.playerArray.me.point
        return "所持ポイント : " + String(point) + "pt"
    }
}

#Preview {
    GameView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
