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
                userDataStore.displayControlPanel = .movement
            }, label: {
                Image(systemName: "square.grid.3x3.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(iconColor(panelMode: .movement))
            })
            Spacer()
            Button(action: {
                userDataStore.displayControlPanel = .negotiation
            }, label: {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(iconColor(panelMode: .negotiation))
            })
//            Spacer()
//            Button(action: {
//                
//            }, label: {
//                Image(systemName: "q.circle.fill")
//                    .font(.system(size: 25))
//            })
//            Spacer()
//            Button(action: {
//                
//            }, label: {
//                Image(systemName: "wand.and.rays")
//                    .font(.system(size: 25))
//            })
            Spacer()
        }
        .background(Color(UIColor.systemGray5))
    }
    func iconColor(panelMode: UserDataStore.controlPanelMode) -> Color {
        let nowPanelMode = userDataStore.displayControlPanel
        if nowPanelMode == panelMode {
            return Color.accentColor
        } else {
            return Color.gray
        }
    }
}

#Preview {
    SelectionView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
