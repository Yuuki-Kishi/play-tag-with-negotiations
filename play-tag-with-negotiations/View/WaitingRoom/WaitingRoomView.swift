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
                Button(action: {
                    Task {
                        await Update.appointmentChaser()
                        await Update.moveToNextPhase()
                        await Update.gameStart()
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 75, height: 75)
                        Image(systemName: "play.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.primary)
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 35)
                .padding(.bottom, 35)
            }
        }
        .navigationTitle("待合室")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onChange(of: playerDataStore.playingRoom.isPlaying) {
            if playerDataStore.playingRoom.isPlaying {
//                if playerDataStore.playerArray.me.isHost {
//                    Task {
//                        
//                        DispatchQueue.main.async {
//                            playerDataStore.currentPhaseOptimistic += 1
//                        }
//                        
//                    }
//                }
                pathDataStore.navigatetionPath.append(.game)
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
            Text("あなたが退出するとこのルームは削除されます。\n再度ルームが必要な場合はルームを作成してください。")
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
            onAppear()
        }
        .onDisappear() {
            onDisappear()
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
                if playerDataStore.playerArray.guestUsers.count == 0 {
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
            let roomId = playerDataStore.playingRoom.roomId.uuidString
            await Delete.deleteRoom(roomId: roomId)
            pathDataStore.navigatetionPath.removeAll()
        }
    }
    func hostExit() {
        Task {
            let roomId = playerDataStore.playingRoom.roomId.uuidString
            await Delete.hostExitRoom(roomId: roomId)
            pathDataStore.navigatetionPath.removeAll()
        }
    }
    func exit() {
        Task {
            let roomId = playerDataStore.playingRoom.roomId.uuidString
            await Delete.exitRoom(roomId: roomId)
            pathDataStore.navigatetionPath.removeAll()
        }
    }
    func onAppear() {
        Observe.observeRoomField()
        Observe.observePlayers()
        Task {
            await Update.randomInitialPosition()
        }
    }
    func onDisappear() {
        userDataStore.listeners[.roomField]?.remove()
        userDataStore.listeners.removeValue(forKey: .roomField)
        userDataStore.listeners[.players]?.remove()
        userDataStore.listeners.removeValue(forKey: .players)
    }
}

#Preview {
    WaitingRoomView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
