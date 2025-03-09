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
                .frame(maxHeight: .infinity)
            HStack {
                Text(displayPhase())
                    .padding(.leading)
                Spacer()
                Text(countDown())
                Spacer()
                Text(point())
                    .padding(.trailing)
            }
            VStack {
                SelectionView(userDataStore: userDataStore, playerDataStore: playerDataStore)
                ControlPanelCoordination(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
                    .frame(height: UIScreen.main.bounds.height * 0.25)
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
        .onChange(of: playerDataStore.playingRoom.isFinished) {
            Task { await PlayerRepository.getAllPlayers() }
            pathDataStore.navigatetionPath.append(.result)
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            Task {
                if playerDataStore.playerArray.me.isHost {
                    PlayTagRoomRepository.observeIsDecided()
                }
                UserRepository.observeUserData()
                PlayerRepository.observeMyPropaty()
                DealRepository.observeDeals()
                FriendShipRepository.observeFriend()
                await UserRepository.getUsersData()
                await PlayerRepository.getAlivePlayers(phaseNow: 1)
                await NegotiationRepository.getNegotiations()
                playerDataStore.selectedPlayers = await PlayerRepository.getAllPlayers()
            }
        }
        .onDisappear() {
            TimerDataStore.shared.invalidate()
            userDataStore.listeners.remove(listenerType: .roomField)
            userDataStore.listeners.remove(listenerType: .isDecided)
            userDataStore.listeners.remove(listenerType: .myPropaty)
            userDataStore.listeners.remove(listenerType: .deal)
        }
    }
    func displayPhase() -> String {
        let phaseNow = String(playerDataStore.playingRoom.phaseNow)
        let phaseMax = String(playerDataStore.playingRoom.phaseMax)
        let text = phaseNow + " / " + phaseMax
        return text
    }
    func countDown() -> String {
        return String("あと") + String(playerDataStore.countDownTimer) + String("秒")
    }
    func point() -> String {
        let point = playerDataStore.playerArray.me.point
        return String(point) + "pt"
    }
}

#Preview {
    GameView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
