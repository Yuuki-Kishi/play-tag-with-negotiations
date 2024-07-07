//
//  RoomInfomationView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/06.
//

import SwiftUI

struct RoomInfomationView: View {
    @Binding var playTagRoom: PlayTagRoom
    
    var body: some View {
        List {
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .roomId)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .hostUserId)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .playTagName)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .phaseMax)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .chaserNumber)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .fugitiveNumber)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .horizontalCount)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .verticalCount)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .isPublic)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .isCanJoinAfter)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .isNegotiate)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .isCanDoQuest)
            RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: .isCanUseItem)
        }
        .navigationTitle("ルーム情報")
    }
}

//#Preview {
//    RoomInfomationView(playTagRoom: PlayTagRoom())
//}
