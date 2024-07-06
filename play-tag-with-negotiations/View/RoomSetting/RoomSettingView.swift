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
    @State var playTagRoom: PlayTagRoom = PlayTagRoom(playTagName: "鬼ごっこ")
    @State private var isShowAlert = false
    @State private var isNavigation = false
    
    var body: some View {
        ZStack {
            List {
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .roomId)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .hostUserId)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .playTagName)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .phaseMax)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .chaserNumber)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .fugitiveNumber)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .horizontalCount)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .verticalCount)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .isPublic)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .isCanJoinAfter)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .isNegotiate)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .isCanDoQuest)
                RoomSettingViewCell(playTagRoom: $playTagRoom, itemType: .isCanUseItem)
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
                    CreateToFirestore.createPlayTagRoom(playTagRoom: playTagRoom)
                    playerDataStore.playingRoom = playTagRoom
                    isNavigation = true
                }, label: {
                    Text("作成")
                })
            }, message: {
                Text("あとから設定を変更することはできません。")
            })
            .navigationDestination(isPresented: $isNavigation) {
                WaitingRoomView(userDataStore: userDataStore, playerDataStore: playerDataStore)
            }
            .navigationTitle("ルーム作成")
        }
    }
}

#Preview {
    RoomSettingView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
