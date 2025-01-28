//
//  PublicRoomsCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/17.
//

import SwiftUI

struct PublicRoomsViewCell: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State var playTagRoom: PlayTagRoom
    
    var body: some View {
        Section {
            Button(action: {
                joinRoom()
            }, label: {
                VStack {
                    Text(playTagRoom.playTagName)
                        .font(.system(size: 30.0))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(playTagRoomPhase())
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(Rectangle())
            })
        }
    }
    func joinRoom() {
        Task {
            if await PlayTagRoomRepository.isExists(roomId: playTagRoom.roomId) {
                guard let playingRoom = await PlayTagRoomRepository.getRoomData(roomId: playTagRoom.roomId) else { return }
                DispatchQueue.main.async {
                    playerDataStore.playingRoom = playingRoom
                }
                await PlayerRepository.enterRoom(roomId: playTagRoom.roomId, isHost: false)
                pathDataStore.navigatetionPath.append(.waitingRoom)
            }
        }
    }
    func playTagRoomPhase() -> String {
        let phaseMax = String(playTagRoom.phaseMax) + "フェーズ"
        let phaseNow = String(playTagRoom.phaseNow) + "フェーズ"
        return phaseNow + " / " + phaseMax
    }
}

//#Preview {
//    PublicRoomsViewCell(playTagRoom: PlayTagRoom())
//}
