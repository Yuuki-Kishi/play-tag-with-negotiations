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
    
    var body: some View {
        List($userDataStore.noticeArray) { notice in
            NoticeViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore, notice: notice)
        }
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
}

#Preview {
    NoticeView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
