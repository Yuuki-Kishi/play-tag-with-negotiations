//
//  SelectionView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/11.
//

import SwiftUI

struct SelectionView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                
            }, label: {
                Image(systemName: "square.grid.3x3.fill")
                    .font(.system(size: 25))
            })
            Spacer()
            Button(action: {
                
            }, label: {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 25))
            })
            Spacer()
            Button(action: {
                
            }, label: {
                Image(systemName: "q.circle.fill")
                    .font(.system(size: 25))
            })
            Spacer()
            Button(action: {
                
            }, label: {
                Image(systemName: "wand.and.rays")
                    .font(.system(size: 25))
            })
            Spacer()
        }
    }
}

#Preview {
    SelectionView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
