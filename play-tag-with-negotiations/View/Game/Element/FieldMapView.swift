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
    @State private var horizontalCount: Int = 5
    @State private var verticalCount: Int = 5
    
    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 5), count: horizontalCount)
        
        ScrollView([.horizontal, .vertical]) {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(0 ..< horizontalCount * verticalCount) { num in
                    Text(changeToCoordinate(num: num))
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                        .background(Color.gray)
                }
            }
            .padding()
        }
    }
    func changeToCoordinate(num: Int) -> String {
        let x = num % horizontalCount
        let y = num / horizontalCount
        let coordinate = "(" + String(x) + ", " + String(y) + ")"
        return coordinate
    }
}

#Preview {
    FieldMapView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
