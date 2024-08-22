//
//  NoticeView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/21.
//

import SwiftUI

struct NoticeView: View {
    @ObservedObject var userDataStore: UserDataStore
    
    var body: some View {
        List($userDataStore.noticeArray) { notice in
            NoticeViewCell(userDataStore: userDataStore, notice: notice)
        }
        .navigationTitle("通知")
        .onAppear() {
            ObserveToFirestore.observeNotice()
        }
    }
}

#Preview {
    NoticeView(userDataStore: UserDataStore.shared)
}
