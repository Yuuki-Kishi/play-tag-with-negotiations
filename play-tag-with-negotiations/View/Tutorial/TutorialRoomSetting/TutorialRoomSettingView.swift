//
//  TutorialRoomSettingView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI
import TipKit

struct TutorialRoomSettingView: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isShowAlert = false
    
    var body: some View {
        VStack {
            TipView(RuleSettingTip())
                .padding(.horizontal)
            List {
                ForEach(PlayTagRoom.displayItemType.allCases, id: \.self) { itemType in
                    TutorialRoomSettingViewCell(tutorialDataStore: tutorialDataStore, itemType: itemType)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowAlert = true
                    }, label: {
                        Text("作成")
                    })
                }
            }
            .alert("ルームを作成しますか？", isPresented: $isShowAlert, actions: {
                Button(role: .cancel, action: {}, label: {
                    Text("キャンセル")
                })
                Button(action: {
                    enterRoom()
                }, label: {
                    Text("作成")
                })
            }, message: {
                Text("あとから設定を変更することはできません。")
            })
            .navigationTitle("ルーム作成")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear() {
                tutorialDataStore.initPlayTagRoom()
            }
        }
    }
    func enterRoom() {
        guard let user = UserDataStore.shared.signInUser else { return }
        let player = Player(playerUserId: user.userId, isHost: true)
        tutorialDataStore.tutorialUserArray.append(noDuplicate: user)
        tutorialDataStore.tutorialPlayerArray.append(noDuplicate: player)
        pathDataStore.navigatetionPath.append(.tutorialWaitingRoom)
    }
}

#Preview {
    TutorialRoomSettingView(tutorialDataStore: TutorialDataStore.shared, pathDataStore: PathDataStore.shared)
}
