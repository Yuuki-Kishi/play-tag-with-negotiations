//
//  WaitingRoomView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/15.
//

import SwiftUI

struct WaitingRoomView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @Environment(\.scenePhase) private var scenePhase
    @State private var previousPhase: ScenePhase = .active
    @State private var isShowExitAlert = false
    @State private var isShowHostAlert = false
    @State private var isShowLastUserAlert = false
    
    var body: some View {
        ZStack {
            
            List {
                Section(content: {
                    WaitingRoomViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, userId: Binding(get: { playerDataStore.playerArray.host.playerUserId }, set: {_ in}))
                }, header: {
                    Text("ホスト")
                })
                Section(content: {
                    ForEach(playerDataStore.playerArray.guests, id: \.playerUserId) { player in
                        WaitingRoomViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, userId: Binding(get: { player.playerUserId }, set: {_ in}))
                    }
                }, header: {
                    Text("ゲスト")
                })
            }
            if userDataStore.signInUser?.userId == playerDataStore.playingRoom.hostUserId {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                await PlayTagRoomRepository.appointmentChaser()
                                await PlayTagRoomRepository.moveToNextPhase()
                                await PlayTagRoomRepository.gameStart()
                            }
                        }, label: {
                            Image(systemName: "play.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(Color.primary)
                                .background(RoundedRectangle(cornerRadius: 25).frame(width: 75, height: 75))
                                .frame(width: 75, height: 75)
                        })
                        .padding(.trailing, 40)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationTitle("待合室")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onChange(of: playerDataStore.playingRoom.isPlaying) {
            if playerDataStore.playingRoom.isPlaying {
                Task { await PlayerRepository.writeIsCatchable() }
                pathDataStore.navigatetionPath.append(.game)
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .alert("最後のプレイヤーです", isPresented: $isShowLastUserAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                lastExit()
            }, label: {
                Text("退出")
            })
        }, message: {
            Text("あなたが退出するとこのルームは削除されます。再度ルームが必要な場合はルームを作成してください。")
        })
        .alert("あなたはホストです", isPresented: $isShowHostAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                hostExit()
            }, label: {
                Text("退出")
            })
        }, message: {
            Text("あなたが退出すると別の人がホストになります。")
        })
        .alert("本当に退出しますか？", isPresented: $isShowExitAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                exit()
            }, label: {
                Text("退出")
            })
        }, message: {
            Text("非公開ルームの場合、再入室するにはルームIDが必要です。")
        })
        .onAppear() {
            Task {
                await PlayerPositionRepository.randomInitialPosition()
                await PlayerRepository.continuePlaying()
            }
            PlayTagRoomRepository.observeRoomField()
            UserRepository.observeUsersData()
            PlayerRepository.observePlayers()
        }
        .onDisappear() {
            userDataStore.listeners.remove(listenerType: .roomField)
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                pathDataStore.navigatetionPath.append(.roomInfo)
            }, label: {
                Label("ルール", systemImage: "info.circle")
            })
            Button(action: {
                pathDataStore.navigatetionPath.append(.invite)
            }, label: {
                Label("フレンドを招待", systemImage: "paperplane.fill")
            })
            Divider()
            Button(role: .destructive, action: {
                guard let userId = userDataStore.signInUser?.userId else { return }
                let hostUserId = playerDataStore.playingRoom.hostUserId
                if playerDataStore.playerArray.count == 1 {
                    isShowLastUserAlert = true
                } else {
                    if userId == hostUserId {
                        isShowHostAlert = true
                    } else {
                        isShowExitAlert = true
                    }
                }
            }, label: {
                Text("退出")
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
    WaitingRoomView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
