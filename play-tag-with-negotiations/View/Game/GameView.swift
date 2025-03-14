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
    @State private var isShowExitGameAlert = false
    
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
                menu()
            })
        }
        .onChange(of: playerDataStore.playingRoom.isFinished) {
            Task { await PlayerRepository.getAllPlayers() }
            pathDataStore.navigatetionPath.append(.result)
        }
        .alert("ゲームを退出しますか？", isPresented: $isShowExitGameAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                if playerDataStore.playerArray.me.isHost {
                    Task { await PlayerRepository.hostExitRoom() }
                } else {
                    Task { await PlayerRepository.exitRoom() }
                }
            }, label: {
                Text("退出")
            })
        }, message: {
            Text("退出するとこれまでの記録が消えます。この操作は取り消すことができません。")
        })
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            onAppear()
        }
        .onDisappear() {
            TimerDataStore.shared.invalidate()
            userDataStore.listeners.remove(listenerType: .isDecided)
            userDataStore.listeners.remove(listenerType: .phaseNow)
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
    func onAppear() {
        Task {
            await UserRepository.getUsersData()
            await PlayerRepository.getAlivePlayers(phaseNow: 1)
            await NegotiationRepository.getNegotiations()
            playerDataStore.selectedPlayers = await PlayerRepository.getAllPlayers()
            PlayTagRoomRepository.observeIsDecided()
            PlayTagRoomRepository.observeRoomFieldAndPhaseNow()
            PlayerRepository.observePlayersPropaty()
            DealRepository.observeDeals()
            FriendShipRepository.observeFriend()
            TimerDataStore.shared.setTimer(limit: 60)
        }
    }
    func menu() -> some View {
        Menu {
            Button(action: {
                pathDataStore.navigatetionPath.append(.roomInfo)
            }, label: {
                Label("ルール", systemImage: "info.circle")
            })
            Divider()
            Button(action: {
                isShowExitGameAlert = true
            }, label: {
                Label("退出", systemImage: "figure.walk.arrival")
            })
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

#Preview {
    GameView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
