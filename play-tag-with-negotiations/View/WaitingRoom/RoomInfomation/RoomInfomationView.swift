//
//  RoomInfomationView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/06.
//

import SwiftUI

struct RoomInfomationView: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        List {
            ForEach(PlayTagRoom.displayItemType.allCases, id: \.self) { itemType in
                RoomInfomationViewCell(playTagRoom: playerDataStore.playingRoom, itemType: itemType)
            }
        }
        .navigationTitle("ルール")
    }
}

//#Preview {
//    RoomInfomationView(playTagRoom: PlayTagRoom())
//}
