//
//  TutorialSelectionView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI
import TipKit

struct TutorialSelectionView: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                tutorialDataStore.tutorialDisplayControlPanel = .movement
            }, label: {
                Image(systemName: "square.grid.3x3.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(iconColor(panelMode: .movement))
            })
            Spacer()
            Button(action: {
                tutorialDataStore.tutorialDisplayControlPanel = .deal(.negotiation)
            }, label: {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(iconColor(panelMode: .deal(.client)))
            })
            Spacer()
            Button(action: {
                tutorialDataStore.tutorialDisplayControlPanel = .playerInfo(.info)
            }, label: {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(iconColor(panelMode: .playerInfo(.players)))
            })
            Spacer()
        }
        .background(Color(UIColor.systemGray5))
    }
    func iconColor(panelMode: UserDataStore.controlPanelMode) -> Color {
        switch tutorialDataStore.tutorialDisplayControlPanel {
        case .movement:
            switch panelMode {
            case .movement:
                return .accentColor
            case .deal:
                return .red
            case .playerInfo:
                return .gray
            }
        case .deal:
            switch panelMode {
            case .movement:
                return .gray
            case .deal:
                return .red
            case .playerInfo:
                return .gray
            }
        case .playerInfo:
            switch panelMode {
            case .movement:
                return .gray
            case .deal:
                return .red
            case .playerInfo:
                return .accentColor
            }
        }
    }
}

#Preview {
    TutorialSelectionView(tutorialDataStore: TutorialDataStore.shared)
}
