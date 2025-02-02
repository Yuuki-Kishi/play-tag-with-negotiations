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
                Text("通知はありません")
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
            Button(action: {
                Task { await NoticeRepository.allCheckNotice() }
            }, label: {
                Label("全て既読", systemImage: "checkmark")
            })
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
