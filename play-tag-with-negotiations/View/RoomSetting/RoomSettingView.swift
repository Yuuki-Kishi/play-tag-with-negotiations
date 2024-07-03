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
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .roomId)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .hostUserId)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .playTagName)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .phaseMax)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .chaserNumber)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .fugitiveNumber)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .horizontalCount)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .verticalCount)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .isPublic)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .isCanJoinAfter)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .isNegotiate)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .isCanDoQuest)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .isCanUseItem)
            }
            Button(action: {
                isShowAlert = true
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 75, height: 75)
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.primary)
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 35)
            .padding(.bottom, 35)
            .alert("ルームを作成しますか？", isPresented: $isShowAlert, actions: {
                Button(role: .cancel, action: {}, label: {
                    Text("キャンセル")
                })
                Button(action: {
                    Create.createPlayTagRoom(playTagRoom: playTagRoom)
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
        }
        .navigationTitle("ルーム作成")
    }
}

#Preview {
    RoomSettingView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
