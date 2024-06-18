//
//  RoomSettingView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/11.
//

import SwiftUI

struct RoomSettingView: View {
    @State var playTagRoom: PlayTagRoom = PlayTagRoom(roomId: UUID(), playTagName: "鬼ごっこ", phaseNow: 0, phaseMax: 10, chaserNumber: 1, fugitiveNumber: 4, isPublic: false, isCanJoinAfter: false, isNegotiate: true, isCanDoQuest: true, isCanUseItem: true)
    @State private var isShowAlert = false
    
    var body: some View {
        ZStack {
            List {
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .roomId)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .playTagName)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .phaseMax)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .chaserNumber)
                RoomSettingCellView(playTagRoom: $playTagRoom, itemType: .fugitiveNumber)
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
                    Image(systemName: "arrow.right")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.primary)
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 35)
            .alert("ルームを作成しますか？", isPresented: $isShowAlert, actions: {
                Button(role: .cancel, action: {}, label: {
                    Text("キャンセル")
                })
                Button(action: {
                    UpdateDocument.createPlayTagRoom(playTagRoom: playTagRoom)
                    
                }, label: {
                    Text("作成")
                })
            }, message: {
                Text("あとから設定を変更することはできません。")
            })
        }
        .navigationTitle("ルーム作成")
    }
}

#Preview {
    RoomSettingView()
}
