//
//  TutorialControlPanelCoordination.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialControlPanelCoordination: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    
    var body: some View {
        switch tutorialDataStore.tutorialDisplayControlPanel {
        case .movement:
            TutorialMovePanelView(tutorialDataStore: tutorialDataStore)
        case .deal(.client):
            EmptyView()
        case .deal(.negotiation):
            TutorialDealPanelView(tutorialDataStore: tutorialDataStore)
        case .playerInfo(.players):
            EmptyView()
        case .playerInfo(.info):
            TutorialPlayerInfoView(tutorialDataStore: tutorialDataStore)
        }
    }
}

#Preview {
    TutorialControlPanelCoordination(tutorialDataStore: TutorialDataStore.shared)
}
