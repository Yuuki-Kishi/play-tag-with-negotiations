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
                if playerDataStore.selectedPlayers.isEmpty {
                    userDataStore.displayControlPanel = .deal(.negotiation)
                } else {
                    userDataStore.displayControlPanel = .deal(.client)
                }
            }, label: {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(iconColor(panelMode: .deal(.client)))
            })
            Spacer()
            Button(action: {
                if playerDataStore.selectedPlayers.isEmpty {
                    userDataStore.displayControlPanel = .playerInfo(.info)
                } else {
                    userDataStore.displayControlPanel = .playerInfo(.players)
                }
            }, label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 25))
                    .foregroundStyle(iconColor(panelMode: .playerInfo(.players)))
            })
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
            case .playerInfo:
                return .gray
            }
        case .deal:
            switch panelMode {
            case .movement:
                return .gray
            case .deal:
                return .accentColor
            case .playerInfo:
                return .gray
            }
        case .playerInfo:
            switch panelMode {
            case .movement:
                return .gray
            case .deal:
                return .gray
            case .playerInfo:
                return .accentColor
            }
        }
    }
}

#Preview {
    SelectionView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
