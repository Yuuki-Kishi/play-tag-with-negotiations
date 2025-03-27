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
    @Environment(\.scenePhase) private var scenePhase
    @State private var previousPhase: ScenePhase = .active
    @State private var isShowWasCapturedAlert = false
    @State private var isShowExitGameAlert = false
    @State private var isRetire = false
    
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
                ControlPanelCoordination(userDataStore: userDataStore, playerDataStore: playerDataStore)
                    .frame(height: UIScreen.main.bounds.height * 0.25)
            }
            .frame(height: UIScreen.main.bounds.height * 0.35)
        }
        .navigationTitle(playerDataStore.playingRoom.playTagName)
        .background(Color(UIColor.systemGray6))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .onChange(of: playerDataStore.playingRoom.isFinished) {
            if !isRetire {
                Task { await PlayerRepository.getAllPlayers() }
                pathDataStore.navigatetionPath.append(.result)
            }
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                previousPhase = .active
            case .inactive:
                switch previousPhase {
                case .active:
                    Task {
                        if playerDataStore.playerArray.me.isHost {
                            await PlayerRepository.playerUpToHost()
                        }
                        await PlayerRepository.stopPlaying()
                    }
                case .inactive:
                    break
                case .background:
                    Task { await PlayerRepository.continuePlaying() }
                @unknown default:
                    break
                }
            case .background:
                previousPhase = .background
            @unknown default:
                break
            }
        }
        .alert("ゲームを退出しますか？", isPresented: $isShowExitGameAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                isRetire = true
                if playerDataStore.playerArray.count == 1 {
                    lastExit()
                } else {
                    if playerDataStore.playerArray.me.isHost {
                        hostExit()
                    } else {
                        exit()
                    }
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
            userDataStore.listeners.remove(listenerType: .usersData)
            userDataStore.listeners.remove(listenerType: .isDecided)
            userDataStore.listeners.remove(listenerType: .phaseNow)
            userDataStore.listeners.remove(listenerType: .deal)
            userDataStore.listeners.remove(listenerType: .game)
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
            await PlayerRepository.continuePlaying()
            await NegotiationRepository.getNegotiations()
            playerDataStore.selectedPlayers = await PlayerRepository.getAllPlayers()
            if pathDataStore.navigatetionPath.count <= 1 {
                UserRepository.observeUsersData()
                PlayerRepository.observePlayers()
            }
            PlayTagRoomRepository.observeRoomFieldAndPhaseNow()
            DealRepository.observeDeals()
            FriendShipRepository.observeFriend()
            TimerDataStore.shared.setTimer(limit: 60)
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                pathDataStore.navigatetionPath.append(.roomInfo)
            }, label: {
                Label("ルール", systemImage: "info.circle")
            })
            Divider()
            Button(role: .destructive, action: {
                isShowExitGameAlert = true
            }, label: {
                Label("退出", systemImage: "figure.walk.arrival")
            })
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func lastExit() {
        Task {
            await PlayTagRoomRepository.deleteRoom()
            pathDataStore.navigatetionPath.removeAll()
        }
    }
    func hostExit() {
        Task {
            await PlayerRepository.hostExitRoom()
            pathDataStore.navigatetionPath.removeAll()
        }
    }
    func exit() {
        Task {
            await PlayerRepository.exitRoom()
            pathDataStore.navigatetionPath.removeAll()
        }
    }
}

#Preview {
    GameView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
