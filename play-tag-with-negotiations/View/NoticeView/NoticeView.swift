//
//  NoticeView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/21.
//

import SwiftUI

struct NoticeView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isShowAlert = false
    
    var body: some View {
        ZStack {
            if !userDataStore.noticeArray.isEmpty {
                List($userDataStore.noticeArray) { notice in
                    NoticeViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore, notice: notice)
                }
            } else {
                Spacer()
                Text("未閲覧の通知はありません")
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .alert("通知を全て削除しますか？", isPresented: $isShowAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                Task { await NoticeRepository.deleteAllNotice() }
            }, label: {
                Text("削除")
            })
        })
        .navigationTitle("通知")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            NoticeRepository.observeNotice()
        }
        .onDisappear() {
            userDataStore.listeners.remove(listenerType: .notice)
            userDataStore.noticeArray.removeAll()
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Menu {
                Button(action: { userDataStore.noticeArray.sort { $0.senderUserId < $1.senderUserId }}, label: {
                    Text("ユーザー名昇順")
                })
                Button(action: { userDataStore.noticeArray.sort { $0.senderUserId > $1.senderUserId }}, label: {
                    Text("ユーザー名降順")
                })
                Button(action: { userDataStore.noticeArray.sort { $0.sendDate < $1.sendDate }}, label: {
                    Text("通知日時昇順")
                })
                Button(action: { userDataStore.noticeArray.sort { $0.sendDate > $1.sendDate }}, label: {
                    Text("通知日時降順")
                })
            } label: {
                Label("並び替え", systemImage: "arrow.up.arrow.down")
            }
            Divider()
            Button(role: .destructive, action: {
                isShowAlert = true
            }, label: {
                Label("全て削除", systemImage: "trash")
            })
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

#Preview {
    NoticeView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
