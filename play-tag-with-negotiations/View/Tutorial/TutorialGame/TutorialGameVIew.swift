//
//  TutorialGameVIew.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialGameVIew: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    @ObservedObject var pathDataStore: PathDataStore
    
    var body: some View {
        VStack {
            TutorialFieldMapView(tutorialDataStore: tutorialDataStore)
                .frame(maxHeight: .infinity)
            HStack {
                Text(String(tutorialDataStore.tutorialPlayTagRoom.phaseNow) + " / 10")
                    .padding(.leading)
                Spacer()
                Text("あと60秒")
                Spacer()
                Text("100pt")
                    .padding(.trailing)
            }
            VStack {
                TutorialSelectionView(tutorialDataStore: tutorialDataStore)
                    .popoverTip(SelectionPanelTip(), arrowEdge: .bottom)
                TutorialControlPanelCoordination(tutorialDataStore: tutorialDataStore)
                    .frame(height: UIScreen.main.bounds.height * 0.25)
            }
            .frame(height: UIScreen.main.bounds.height * 0.35)
        }
        .navigationTitle("チュートリアル")
        .background(Color(UIColor.systemGray6))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {}, label: {
                    Image(systemName: "ellipsis.circle")
                })
            })
        }
        .onChange(of: tutorialDataStore.tutorialPlayTagRoom.isFinished) {
            pathDataStore.navigatetionPath.append(.TutorialResult)
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            guard let player = tutorialDataStore.tutorialPlayerArray.randomElement() else { return }
            tutorialDataStore.tutorialSelectetPlayer = player
        }
    }
}

#Preview {
    TutorialGameVIew(tutorialDataStore: TutorialDataStore.shared, pathDataStore: PathDataStore.shared)
}
