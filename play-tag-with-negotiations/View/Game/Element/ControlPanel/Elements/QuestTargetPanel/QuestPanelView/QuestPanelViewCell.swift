//
//  QuestPanelViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/14.
//

import SwiftUI

struct QuestPanelViewCell: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    @Binding var quest: Quest
    @State var questType: Quest.qusetCondition
    
    var body: some View {
        HStack {
            Image(systemName: mission().imageName)
                .font(.system(size: 25))
                .frame(width: 50)
                .foregroundStyle(Color.accentColor)
            VStack {
                Text(mission().displayName)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("報酬" + String(mission().reward) + "pt")
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    func mission() -> Mission {
        return playerDataStore.missionArray.mission(missionId: quest.missionId)
    }
}

//#Preview {
//    QuestPanelViewCell()
//}
