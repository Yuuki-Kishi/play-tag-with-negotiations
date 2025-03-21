//
//  TutorialResultView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI
import TipKit

struct TutorialResultView: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    @ObservedObject var pathDataStore: PathDataStore
    
    var body: some View {
        VStack {
            Spacer()
            Text("1st")
                .foregroundStyle(Color.pink)
                .font(.system(size: 150))
                .frame(height: UIScreen.main.bounds.height * 0.2)
            TipView(FriendShipTip())
                .padding(.horizontal)
            List($tutorialDataStore.tutorialPlayerArray) { player in
                TutorialResultViewCell(tutorialDataStore: tutorialDataStore, player: player)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    let count = pathDataStore.navigatetionPath.count
                    pathDataStore.navigatetionPath.remove(atOffsets: IndexSet(integersIn: Range(2 ... count)))
                }, label: {
                    Text("確認")
                })
            })
        }
        .navigationTitle("結果")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TutorialResultView(tutorialDataStore: TutorialDataStore.shared, pathDataStore: PathDataStore.shared)
}
