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
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: squareSize(), height: squareSize())
                        .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
                }
            }
            .padding()
        }
        .background(Color.clear)
    }
    func changeToCoordinate(num: Int) -> String {
        let x = num % playerDataStore.playingRoom.horizontalCount
        let y = num / playerDataStore.playingRoom.horizontalCount
        let coordinate = "(" + String(x) + ", " + String(y) + ")"
        return coordinate
    }
    func squareSize() -> CGFloat {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height * 0.6
        if width > height {
            return height * 0.8 / CGFloat(playerDataStore.playingRoom.horizontalCount)
        } else {
            return width * 0.8 / CGFloat(playerDataStore.playingRoom.horizontalCount)
        }
    }
}

#Preview {
    FieldMapView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
