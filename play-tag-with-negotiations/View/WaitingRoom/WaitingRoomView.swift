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
    @State private var isShowAlert = false
    @State private var isShowLastUserAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            List {
                Section(content: {
                    WaitingRoomCellView(userDataStore: userDataStore, user: $playerDataStore.hostUser)
                }, header: {
                    Text("ホスト")
                })
                Section(content: {
                    ForEach($playerDataStore.userSet, id: \.self) { user in
                        if user.wrappedValue != playerDataStore.hostUser {
                            WaitingRoomCellView(userDataStore: userDataStore, user: user)
                        }
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
        .alert("本当に退出しますか？", isPresented: $isShowAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                Task {
                    guard let roomId = playerDataStore.playingRoom?.roomId.uuidString else { return }
                    await Delete.exitRoom(roomId: roomId)
                    dismiss()
                }
            }, label: {
                Text("退出")
            })
        }, message: {
            Text("再入室する場合はルームIDが必要です。")
        })
        .alert("最後のプレイヤーです", isPresented: $isShowLastUserAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                Task {
                    guard let roomId = playerDataStore.playingRoom?.roomId.uuidString else { return }
                    await Delete.deleteRoom(roomId: roomId)
                    dismiss()
                }
            }, label: {
                Text("退出")
            })
        }, message: {
            Text("あなたが退出するとこのルームは削除されます。\n再度ルームが必要な場合はルームを作成してください。")
        })
        .onAppear() {
            Observe.observePlayer()
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            NavigationLink(destination: {}, label: {
                Label("ルーム情報", systemImage: "info.circle")
            })
            Divider()
            Button(role: .destructive, action: {
                if playerDataStore.playerSet.count > 1 {
                    isShowAlert = true
                } else {
                    isShowLastUserAlert = true
                }
            }, label: {
                Text("退出")
            })
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

#Preview {
    WaitingRoomView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
