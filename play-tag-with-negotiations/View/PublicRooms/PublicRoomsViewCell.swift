//
//  PublicRoomsCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/17.
//

import SwiftUI

struct PublicRoomsViewCell: View {
    @Binding var playTagRoom: PlayTagRoom
    
    var body: some View {
        Section {
            NavigationLink(value: playTagRoom, label: {
                VStack {
                    Text(playTagRoom.playTagName)
                        .font(.system(size: 30.0))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(playTagRoomPhase(playTagRoom: playTagRoom))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(Rectangle())
            })
        }
    }
    func playTagRoomPhase(playTagRoom: PlayTagRoom) -> String {
        let phaseMax = String(playTagRoom.phaseMax) + "フェーズ"
        let phaseNow = String(playTagRoom.phaseNow) + "フェーズ"
        return phaseNow + " / " + phaseMax
    }
}

//#Preview {
//    PublicRoomsViewCell(playTagRoom: PlayTagRoom())
//}
