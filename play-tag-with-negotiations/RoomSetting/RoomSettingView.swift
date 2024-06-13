//
//  RoomSettingView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/11.
//

import SwiftUI

struct RoomSettingView: View {
    @State private var roomId = UUID()
    @State private var playTagName: String
    @State private var phaseNow = 0
    @State private var phaseMax = 10
    @State private var chaserNumber = 1
    @State private var fugitiveNumber = 4
    @State private var isPublic = false
    @State private var isCanJoinAfter = false
    @State private var isNegotiate = true
    @State private var isCanDoQuest = true
    @State private var isCanUseItem = true
    @State private var isShowAlert = false
    
    init(playTagName: String) {
        self.playTagName = playTagName
    }
    
    var body: some View {
        ZStack {
            List {
                RoomSettingCellView(itemElement: "ルームID", stringDataElement: roomId.uuidString, itemType: .UUID)
                RoomSettingCellView(itemElement: "鬼ごっこ名", stringDataElement: playTagName, itemType: .String)
                RoomSettingCellView(itemElement: "最大フェーズ", stringDataElement: String(phaseMax), itemType: .Int)
                RoomSettingCellView(itemElement: "鬼の人数", stringDataElement: String(chaserNumber), itemType: .Int)
                RoomSettingCellView(itemElement: "逃走者の人数", stringDataElement: String(fugitiveNumber), itemType: .Int)
                RoomSettingCellView(itemElement: "公開", boolDataElement: isPublic, itemType: .Bool)
                RoomSettingCellView(itemElement: "途中参加", boolDataElement: isCanJoinAfter, itemType: .Bool)
                RoomSettingCellView(itemElement: "交渉", boolDataElement: isNegotiate, itemType: .Bool)
                RoomSettingCellView(itemElement: "クエスト", boolDataElement: isCanDoQuest, itemType: .Bool)
                RoomSettingCellView(itemElement: "アイテム", boolDataElement: isCanUseItem, itemType: .Bool)
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
    RoomSettingView(playTagName: "鬼ごっこ名")
}
