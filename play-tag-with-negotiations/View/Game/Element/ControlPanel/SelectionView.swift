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
                userDataStore.displayControlPanel = .deal(.negotiation)
            }, label: {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(iconColor(panelMode: .deal(.negotiation)))
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
        switch userDataStore.displayControlPanel {
        case .movement:
            switch panelMode {
            case .movement:
                return .accentColor
            case .deal:
                return .gray
            }
        case .deal:
            switch panelMode {
            case .movement:
                return .gray
            case .deal:
                return .accentColor
            }
        }
    }
}

#Preview {
    SelectionView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
