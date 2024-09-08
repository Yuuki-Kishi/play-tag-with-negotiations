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
                    FieldMapViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, num: num)
                }
            }
            .padding()
        }
        .background(Color.clear)
//        .onAppear() {
//            print(playerDataStore.playingRoom.horizontalCount, playerDataStore.playingRoom.verticalCount)
//        }
    }
}

#Preview {
    FieldMapView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
