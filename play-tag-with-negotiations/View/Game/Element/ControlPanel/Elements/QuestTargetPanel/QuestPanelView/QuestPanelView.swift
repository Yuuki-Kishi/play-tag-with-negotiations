//
//  QuestPanelView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/14.
//

import SwiftUI

struct QuestPanelView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        List {
            if !playerDataStore.questArray.executing.isEmpty {
                Section(content: {
                    ForEach(playerDataStore.questArray.completed, id: \.self) { quest in
                        QuestPanelViewCell(playerDataStore: playerDataStore, quest: Binding(get: { quest }, set: {_ in}), questType: .executing)
                    }
                }, header: {
                    Text("実行中のクエスト")
                })
            }
            if !playerDataStore.missionArray.canExecute.isEmpty {
                Section(content: {
                    ForEach(playerDataStore.missionArray.canExecute, id: \.self) { mission in
                        
                    }
                }, header: {
                    Text("提案できる取引")
                })
            }
            if !playerDataStore.questArray.failured.isEmpty {
                Section(content: {
                    ForEach(playerDataStore.questArray.failured, id: \.self) { quest in
                        QuestPanelViewCell(playerDataStore: playerDataStore, quest: Binding(get: { quest }, set: {_ in}), questType: .failured)
                    }
                }, header: {
                    Text("失敗したクエスト")
                })
            }
            if !playerDataStore.questArray.completed.isEmpty {
                Section(content: {
                    ForEach(playerDataStore.questArray.completed, id: \.self) { quest in
                        QuestPanelViewCell(playerDataStore: playerDataStore, quest: Binding(get: { quest }, set: {_ in}), questType: .completed)
                    }
                }, header: {
                    Text("完了した取引")
                })
            }
        }
    }
}

#Preview {
    QuestPanelView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
