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
    @State private var isShowExitAlert = false
    @State private var isShowHostAlert = false
    @State private var isShowLastUserAlert = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var envData: EnvironmentData
    
    var body: some View {
        ZStack {
            List {
                Section(content: {
                    WaitingRoomViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, user: $playerDataStore.hostUser)
                }, header: {
                    Text("ホスト")
                })
                Section(content: {
                    ForEach($playerDataStore.guestUserArray, id: \.self) { user in
                        WaitingRoomViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, user: user)
                    }
                }, header: {
                    Text("ゲスト")
                })
            }
            if userDataStore.signInUser?.userId == playerDataStore.playingRoom?.hostUserId {
                Button(action: {
                    
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
            NavigationLink(destination: {
                RoomInfomationView(playTagRoom: Binding(get: { playerDataStore.playingRoom ?? PlayTagRoom() }, set: { playerDataStore.playingRoom = $0 }))
            }, label: {
                Label("ルーム情報", systemImage: "info.circle")
            })
            Divider()
            Button(role: .destructive, action: {
                guard let userId = userDataStore.signInUser?.userId else { return }
                guard let hostUserId = playerDataStore.playingRoom?.hostUserId else { return }
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
            guard let roomId = playerDataStore.playingRoom?.roomId.uuidString else { return }
            await DeleteToFirestore.deleteRoom(roomId: roomId)
            dismiss()
//            envData.isNavigationFromPublicRoomsView.wrappedValue = false
        }
    }
    func hostExit() {
        Task {
            guard let roomId = playerDataStore.playingRoom?.roomId.uuidString else { return }
            await DeleteToFirestore.hostExitRoom(roomId: roomId)
            dismiss()
//            envData.isNavigationFromPublicRoomsView.wrappedValue = false
        }
    }
    func exit() {
        Task {
            guard let roomId = playerDataStore.playingRoom?.roomId.uuidString else { return }
            await DeleteToFirestore.exitRoom(roomId: roomId)
            dismiss()
//            envData.isNavigationFromPublicRoomsView.wrappedValue = false
        }
    }
    func onAppear() {
        guard let roomId = playerDataStore.playingRoom?.roomId.uuidString else { return }
        ObserveToFirestore.observePlayer()
        ObserveToFirestore.observeRoomField(roomId: roomId)
    }
}

#Preview {
    WaitingRoomView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
