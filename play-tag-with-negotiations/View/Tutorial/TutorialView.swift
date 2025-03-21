//
//  TutorialView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialView: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    @ObservedObject var pathDataStore: PathDataStore
    
    var body: some View {
        VStack {
            let iconHeight = UIScreen.main.bounds.height / 4
            VStack {
                Spacer()
                Image("Icon")
                    .resizable()
                    .frame(width: iconHeight, height: iconHeight)
                    .clipShape(RoundedRectangle(cornerRadius: iconHeight * 0.1675))
                Spacer()
                Text("チュートリアルを見て\n遊び方を習得しよう!\n\nLet's see the tutorial!")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                Spacer()
                Button(action: {
                    pathDataStore.navigatetionPath.append(.tutorialPublicRooms)
                }, label: {
                    Text("見に行く")
                        .foregroundStyle(Color.primary)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.background).frame(width: iconHeight, height: iconHeight * 0.15))
                        .frame(width: iconHeight, height: iconHeight * 0.15)
                        .font(.system(size: 20))
                })
                Spacer()
            }
        }
        .navigationTitle("チュートリアル")
    }
}

#Preview {
    TutorialView(tutorialDataStore: TutorialDataStore.shared, pathDataStore: PathDataStore.shared)
}
