//
//  TutorialMovePanelView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialFieldMapView: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    
    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 5), count: tutorialDataStore.tutorialPlayTagRoom.horizontalCount)
        
        ScrollView([.horizontal, .vertical]) {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(0 ..< tutorialDataStore.tutorialPlayTagRoom.horizontalCount * tutorialDataStore.tutorialPlayTagRoom.verticalCount) { num in
                    TutorialFieldMapViewCell(tutorialDataStore: tutorialDataStore, num: num)
                }
            }
            .padding()
        }
        .background(Color.clear)
    }
}

#Preview {
    TutorialFieldMapView(tutorialDataStore: TutorialDataStore.shared)
}
