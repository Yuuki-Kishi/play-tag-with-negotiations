//
//  RoomInfomationView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/06.
//

import SwiftUI

struct RoomInfomationView: View {
    @State var playTagRoom: PlayTagRoom
    
    var body: some View {
        List {
            ForEach(PlayTagRoom.displayItemType.allCases, id: \.self) { itemType in
                RoomInfomationViewCell(playTagRoom: playTagRoom, itemType: itemType)
            }
        }
        .navigationTitle("ルーム情報")
    }
}

//#Preview {
//    RoomInfomationView(playTagRoom: PlayTagRoom())
//}
