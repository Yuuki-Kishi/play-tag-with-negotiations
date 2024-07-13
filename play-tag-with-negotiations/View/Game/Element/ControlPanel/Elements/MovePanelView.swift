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
                        .font(.system(size: 80).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.up.square.fill")
                        .font(.system(size: 80).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.up.right.square.fill")
                        .font(.system(size: 80).weight(.semibold))
                })
            }
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.left.square.fill")
                        .font(.system(size: 80).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    ZStack {
                        Image(systemName: "octagon.fill")
                            .font(.system(size: 73).weight(.semibold))
                    }
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.right.square.fill")
                        .font(.system(size: 80).weight(.semibold))
                })
            }
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.down.left.square.fill")
                        .font(.system(size: 80).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.down.square.fill")
                        .font(.system(size: 80).weight(.semibold))
                })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.down.right.square.fill")
                        .font(.system(size: 80).weight(.semibold))
                })
            }
        }
    }
}

#Preview {
    MovePanelView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
