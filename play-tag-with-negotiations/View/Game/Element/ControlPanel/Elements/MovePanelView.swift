//
//  MovePanel.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/12.
//

import SwiftUI

struct MovePanelView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.up.left.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.up.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.up.right.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
            }
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.left.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                Button(action: {
                    
                }, label: {
                    ZStack {
                        Image(systemName: "octagon.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.right.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
            }
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.down.left.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.down.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.down.right.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
            }
        }
    }
}

#Preview {
    MovePanelView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
