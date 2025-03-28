//
//  FightRecordView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/28.
//

import SwiftUI

struct FightRecordView: View {
    @ObservedObject var userDataStore: UserDataStore
    
    var body: some View {
        ZStack {
            if !userDataStore.fightRecordArray.isFinished.isEmpty {
                List(userDataStore.fightRecordArray.isFinished) { playedRoom in
                    FightRecordViewCell(playedRoom: Binding(get: { playedRoom }, set: {_ in}))
                }
            } else {
                Text("表示できる戦績はありません")
            }
        }
        .navigationTitle("戦績")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                
            })
        }
        .onAppear() {
            Task { await PlayedRoomRepository.getPlayedRooms() }
        }
    }
}

#Preview {
    FightRecordView(userDataStore: UserDataStore.shared)
}
