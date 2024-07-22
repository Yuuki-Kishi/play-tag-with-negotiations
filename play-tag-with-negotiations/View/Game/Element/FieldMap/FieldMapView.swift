//
//  FieldMap.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import SwiftUI

struct FieldMapView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 5), count: playerDataStore.playingRoom.horizontalCount)
        
        ScrollView([.horizontal, .vertical]) {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(0 ..< playerDataStore.playingRoom.horizontalCount * playerDataStore.playingRoom.verticalCount) { num in
                    let playerPosition = changeToPlayerPosition(num: num)
                    let players = playerDataStore.playerArray.filter({ $0.playerPosition == playerPosition })
                    FieldMapViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, players: players)
                }
            }
            .padding()
        }
        .background(Color.clear)
    }
    func changeToPlayerPosition(num: Int) -> PlayerPosition {
        let x = num % playerDataStore.playingRoom.horizontalCount
        let y = num / playerDataStore.playingRoom.horizontalCount
        let playerPosition = PlayerPosition(x: x, y: y)
        let players = playerDataStore.playerArray.filter({ $0.playerPosition == playerPosition })
        print(players.count)
        return playerPosition
    }
}

#Preview {
    FieldMapView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
