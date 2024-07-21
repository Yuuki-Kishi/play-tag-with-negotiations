//
//  RoomSettingView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/11.
//

import SwiftUI

struct RoomSettingView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isShowAlert = false
    
    var body: some View {
        ZStack {
            List {
                ForEach(PlayTagRoom.displayItemType.allCases, id: \.self) { itemType in
                    RoomSettingViewCell(playerDataStore: playerDataStore, itemType: itemType)
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
                    Task {
                        await CreateToFirestore.createPlayTagRoom(playTagRoom: playerDataStore.playingRoom)
                        pathDataStore.navigatetionPath.append(.waitingRoom)
                    }
                }, label: {
                    Text("作成")
                })
            }, message: {
                Text("あとから設定を変更することはできません。")
            })
            .navigationTitle("ルーム作成")
            .onAppear() {
                playerDataStore.playingRoom = PlayTagRoom(playTagName: "鬼ごっこ")
            }
        }
    }
}

#Preview {
    RoomSettingView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
