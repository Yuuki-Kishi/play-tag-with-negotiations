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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            List {
                Section(content: {
                    WaitingRoomViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, user: $playerDataStore.hostUser)
                }, header: {
                    Text("ホスト")
                })
                Section(content: {
                    ForEach($playerDataStore.guestUserArray, id: \.userId) { user in
                        WaitingRoomViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, user: user)
                    }
                }, header: {
                    Text("ゲスト")
                })
            }
            if userDataStore.signInUser?.userId == playerDataStore.playingRoom.hostUserId {
                Button(action: {
                    Task {
                        await UpdateToFirestore.gameStart()
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
        .navigationBarBackButtonHidden(true)
        .onChange(of: playerDataStore.playingRoom.isPlaying) {
            if playerDataStore.playingRoom.isPlaying {
                guard let myUserId = userDataStore.signInUser?.userId else { return }
                let hostUserId = playerDataStore.playingRoom.hostUserId
                if myUserId == hostUserId {
                    Task {
                        await UpdateToFirestore.appointmentChaser()
                        await UpdateToFirestore.moveToNextPhase()
                    }
                }
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
                guard let userId = userDataStore.signInUser?.userId else { return }
                let hostUserId = playerDataStore.playingRoom.hostUserId
                if playerDataStore.guestUserArray.count == 0 {
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
            await DeleteToFirestore.deleteRoom(roomId: roomId)
            pathDataStore.navigatetionPath.removeAll()
        }
    }
    func hostExit() {
        Task {
            let roomId = playerDataStore.playingRoom.roomId.uuidString
            await DeleteToFirestore.hostExitRoom(roomId: roomId)
            pathDataStore.navigatetionPath.removeAll()
        }
    }
    func exit() {
        Task {
            let roomId = playerDataStore.playingRoom.roomId.uuidString
            await DeleteToFirestore.exitRoom(roomId: roomId)
            pathDataStore.navigatetionPath.removeAll()
        }
    }
    func onAppear() {
        let roomId = playerDataStore.playingRoom.roomId.uuidString
        ObserveToFirestore.observePlayers()
        ObserveToFirestore.observeRoomField(roomId: roomId)
        Task {
            await UpdateToFirestore.randomInitialPosition()
        }
    }
}

#Preview {
    WaitingRoomView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
