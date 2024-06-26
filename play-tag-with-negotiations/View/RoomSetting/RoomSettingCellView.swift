//
//  RoomSettingCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/11.
//

import SwiftUI

struct RoomSettingCellView: View {
    @Binding var playTagRoom: PlayTagRoom
    @State var itemType: RoomSettingCellView.itemTypeEnum
    @State private var text = ""
    @State private var isShowCopiedAlert = false
    @State private var isShowStringAlert = false
    @State private var isShowIntAlert = false
    enum itemTypeEnum { case roomId, playTagName, phaseMax, chaserNumber, fugitiveNumber, horizontalCount,
        verticalCount, isPublic, isCanJoinAfter, isNegotiate, isCanDoQuest, isCanUseItem }
    
    var body: some View {
        switch itemType {
        case .roomId:
            uuidCell(item: "ルームID", data: playTagRoom.roomId.uuidString)
        case .playTagName:
            stringCell(item: "鬼ごっこ名", data: playTagRoom.playTagName)
        case .phaseMax:
            intCell(item: "最大フェーズ", data: playTagRoom.phaseMax)
        case .chaserNumber:
            intCell(item: "鬼の人数", data: playTagRoom.chaserNumber)
        case .fugitiveNumber:
            intCell(item: "逃走者の人数", data: playTagRoom.fugitiveNumber)
        case .horizontalCount:
            intCell(item: "横のマスの数", data: playTagRoom.horizontalCount)
        case .verticalCount:
            intCell(item: "縦のますの数", data: playTagRoom.verticalCount)
        case .isPublic:
            Toggle("公開", isOn: $playTagRoom.isPublic)
                .onChange(of: playTagRoom.isPublic) {
                    if playTagRoom.isPublic {
                        playTagRoom.isCanJoinAfter = true
                    }
                }
        case .isCanJoinAfter:
            Toggle("途中参加", isOn: $playTagRoom.isCanJoinAfter)
                .onChange(of: playTagRoom.isCanJoinAfter) {
                    if !playTagRoom.isCanJoinAfter {
                        playTagRoom.isPublic = false
                    }
                }
        case .isNegotiate:
            Toggle("交渉", isOn: $playTagRoom.isNegotiate)
        case .isCanDoQuest:
            Toggle("クエスト", isOn: $playTagRoom.isCanDoQuest)
        case .isCanUseItem:
            Toggle("アイテム", isOn: $playTagRoom.isCanUseItem)
        }
    }
    func checkTextIsNumber(before: Int, after: String) -> Int {
        if let result = Int(after) {
            if result > 0 {
                return Int(after) == nil ? before : Int(after)!
            }
        }
        return before
    }
    func uuidCell(item: String, data: String) -> some View {
        HStack {
            Text(item)
                .frame(alignment: .leading)
            Spacer()
            Text(data)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .foregroundStyle(Color.gray)
                .font(.system(size: 12))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            UIPasteboard.general.string = data
            isShowCopiedAlert = true
        }
        .alert("コピーしました", isPresented: $isShowCopiedAlert, actions: {
            Button(action: {}, label: {
                Text("OK")
            })
        }, message: {
            Text("ルームIDをクリップボードにコピーしました。")
        })
    }
    func stringCell(item: String, data: String) -> some View {
        HStack {
            Text(item)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(data)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .foregroundStyle(Color.gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            text = ""
            isShowStringAlert = true
        }
        .alert(item + "を変更", isPresented: $isShowStringAlert, actions: {
            TextField(item, text: $text)
            Button("キャンセル", role: .cancel, action: {})
            Button("変更", action: {
                playTagRoom.playTagName = text
                isShowStringAlert = false
            })
        })
    }
    func intCell(item: String, data: Int) -> some View {
        HStack {
            Text(item)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(String(data))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .foregroundStyle(Color.gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            text = ""
            isShowIntAlert = true
        }
        .alert(item + "を変更", isPresented: $isShowIntAlert, actions: {
            TextField(item, text: $text)
            Button("キャンセル", role: .cancel, action: {})
            Button("変更", action: {
                switch itemType {
                case .phaseMax:
                    playTagRoom.phaseMax = checkTextIsNumber(before: playTagRoom.phaseMax, after: text)
                case .chaserNumber:
                    playTagRoom.chaserNumber = checkTextIsNumber(before: playTagRoom.chaserNumber, after: text)
                case .fugitiveNumber:
                    playTagRoom.fugitiveNumber = checkTextIsNumber(before: playTagRoom.chaserNumber, after: text)
                default:
                    break
                }
                isShowStringAlert = false
            })
        })
    }
}

//#Preview {
//    RoomSettingCellView(playTagRoom: PlayTagRoom(), itemType: .roomId)
//}
