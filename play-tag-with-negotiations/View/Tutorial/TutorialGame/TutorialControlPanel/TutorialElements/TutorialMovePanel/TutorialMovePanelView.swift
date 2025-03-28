//
//  TutorialMovePanelViewButton.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialMovePanelView: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    
    var body: some View {
        VStack {
            HStack {
                TutorialMovePanelViewButton(tutorialDataStore: tutorialDataStore, direction: .leftUp)
                TutorialMovePanelViewButton(tutorialDataStore: tutorialDataStore, direction: .up)
                TutorialMovePanelViewButton(tutorialDataStore: tutorialDataStore, direction: .rightUp)
            }
            HStack {
                TutorialMovePanelViewButton(tutorialDataStore: tutorialDataStore, direction: .left)
                TutorialMovePanelViewButton(tutorialDataStore: tutorialDataStore, direction: .stay)
                TutorialMovePanelViewButton(tutorialDataStore: tutorialDataStore, direction: .right)
            }
            HStack {
                TutorialMovePanelViewButton(tutorialDataStore: tutorialDataStore, direction: .leftDowm)
                TutorialMovePanelViewButton(tutorialDataStore: tutorialDataStore, direction: .dowm)
                TutorialMovePanelViewButton(tutorialDataStore: tutorialDataStore, direction: .rightDown)
            }
        }
    }
}

#Preview {
    TutorialMovePanelView(tutorialDataStore: TutorialDataStore.shared)
}
