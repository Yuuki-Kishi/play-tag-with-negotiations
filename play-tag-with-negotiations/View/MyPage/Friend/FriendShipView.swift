//
//  FriendView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import SwiftUI

struct FriendShipView: View {
    @ObservedObject var userDataStore: UserDataStore
    @StateObject var friendDataStore =  FriendDataStore.shared
    @State private var isShowRequestAlert = false
    @State private var isShowSendedAlert = false
    @State private var consenterUserId = ""
    
    enum status: String, CaseIterable, Identifiable {
        case friend
        case pending
        case applying
        
        var displayName: String {
            switch self {
            case .friend: return "フレンド"
            case .pending: return "届いた申請"
            case .applying: return "送った申請"
            }
        }
        var id: Self {
            self
        }
    }
    
    @State var pickerStatus: FriendShipView.status = .friend
    
    var body: some View {
        VStack {
            Picker("フレンド", selection: $pickerStatus) {
                ForEach(status.allCases) { status in
                    Text(status.displayName)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            switch pickerStatus {
            case .friend:
                if !friendDataStore.friendShips.friends.isEmpty {
                    List(friendDataStore.friendShips.friends) { friendShip in
                        FriendViewCell(friendShip: Binding(get: { friendShip }, set: {_ in}))
                    }
                } else {
                    Spacer()
                    Text("フレンドがいません")
                    Spacer()
                }
            case .pending:
                if !friendDataStore.friendShips.pendings.isEmpty {
                    List(friendDataStore.friendShips.pendings) { friendShip in
                        PendingViewCell(friendShip: Binding(get: { friendShip }, set: {_ in}))
                    }
                } else {
                    Spacer()
                    Text("保留中のフレンド申請はありません")
                    Spacer()
                }
            case .applying:
                if !friendDataStore.friendShips.applyings.isEmpty {
                    List(friendDataStore.friendShips.applyings) { friendShip in
                        ApplyingViewCell(friendShip: Binding(get: { friendShip }, set: {_ in}))
                    }
                } else {
                    Spacer()
                    Text("フレンド申請中のプレイヤーはいません")
                    Spacer()
                }
            }
        }
        .navigationTitle("フレンド")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    isShowRequestAlert = true
                }, label: {
                    Image(systemName: "plus")
                })
            })
        }
        .alert("フレンド申請を送る", isPresented: $isShowRequestAlert, actions: {
            TextField("ユーザーID", text: $consenterUserId)
            Button(action: {
                if consenterUserId != "" {
                    Task {
                        await FriendShipRepository.sendFriendRequest(consenter: consenterUserId)
                        isShowSendedAlert = true
                    }
                }
            }, label: {
                Text("送信")
            })
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
        }, message: {
            Text("フレンドのユーザーIDを入力してください。")
        })
        .alert("フレンド申請を送信しました", isPresented: $isShowSendedAlert, actions: {
            Button(action: {}, label: {
                Text("OK")
            })
        })
        .onAppear() {
            FriendShipRepository.observeFriend()
        }
        .onDisappear() {
            userDataStore.listeners.remove(listenerType: .friendShips)
        }
    }
}

#Preview {
    FriendShipView(userDataStore: UserDataStore.shared, friendDataStore: FriendDataStore.shared)
}
