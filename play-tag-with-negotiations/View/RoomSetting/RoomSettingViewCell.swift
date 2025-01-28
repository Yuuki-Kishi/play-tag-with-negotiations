//
//  RoomSettingCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/11.
//

import SwiftUI

struct RoomSettingViewCell: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    @State var itemType: PlayTagRoom.displayItemType
    @State private var text = ""
    @State private var isShowCopiedAlert = false
    @State private var isShowStringAlert = false
    @State private var isShowIntAlert = false
    
    var body: some View {
        switch itemType {
        case .roomId:
            uuidCell(item: "ルームID", data: playerDataStore.playingRoom.roomId)
        case .hostUserId:
            hostUserIdCell(item: "ホストユーザーID", data: playerDataStore.playingRoom.hostUserId)
        case .playTagName:
            playTagNameCell(item: "鬼ごっこ名", data: playerDataStore.playingRoom.playTagName)
        case .creationDate:
            dateCell(item: "作成日時", data: playerDataStore.playingRoom.creationDate)
        case .phaseMax:
            intCell(item: "最大フェーズ", data: playerDataStore.playingRoom.phaseMax)
        case .chaserNumber:
            intCell(item: "鬼の人数", data: playerDataStore.playingRoom.chaserNumber)
        case .fugitiveNumber:
            intCell(item: "逃走者の人数", data: playerDataStore.playingRoom.fugitiveNumber)
        case .horizontalCount:
            intCell(item: "横のマスの数", data: playerDataStore.playingRoom.horizontalCount)
        case .verticalCount:
            intCell(item: "縦のマスの数", data: playerDataStore.playingRoom.verticalCount)
        case .isPublic:
            Toggle("公開", isOn: $playerDataStore.playingRoom.isPublic)
        case .isCanJoinAfter:
            Toggle("途中参加", isOn: $playerDataStore.playingRoom.isCanJoinAfter)
        case .isDeal:
            Toggle("交渉", isOn: $playerDataStore.playingRoom.isDeal)
        }
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
    func hostUserIdCell(item: String, data: String) -> some View {
        HStack {
            Text(item)
                .frame(alignment: .leading)
            Spacer()
            Text(data)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .foregroundStyle(Color.gray)
        }
    }
    func playTagNameCell(item: String, data: String) -> some View {
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
                playerDataStore.playingRoom.playTagName = text
                isShowStringAlert = false
            })
        })
    }
    func dateCell(item: String, data: Date) -> some View {
        HStack {
            Text(item)
                .frame(alignment: .leading)
            Spacer()
            Text(dateToString(date: data))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .foregroundStyle(Color.gray)
        }
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
                    playerDataStore.playingRoom.phaseMax = checkTextIsNumber(before: playerDataStore.playingRoom.phaseMax, after: text)
                case .chaserNumber:
                    playerDataStore.playingRoom.chaserNumber = checkTextIsNumber(before: playerDataStore.playingRoom.chaserNumber, after: text)
                case .fugitiveNumber:
                    playerDataStore.playingRoom.fugitiveNumber = checkTextIsNumber(before: playerDataStore.playingRoom.chaserNumber, after: text)
                case .horizontalCount:
                    playerDataStore.playingRoom.horizontalCount = checkTextIsNumber(before: playerDataStore.playingRoom.horizontalCount, after: text)
                case .verticalCount:
                    playerDataStore.playingRoom.verticalCount = checkTextIsNumber(before: playerDataStore.playingRoom.verticalCount, after: text)
                default:
                    break
                }
                isShowStringAlert = false
            })
        })
    }
    func checkTextIsNumber(before: Int, after: String) -> Int {
        if let result = Int(after) {
            if result > 0 {
                return Int(after) == nil ? before : Int(after)!
            }
        }
        return before
    }
    func dateToString(date: Date) -> String {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFomatter.string(from: date)
    }
}

//#Preview {
//    RoomSettingCellView(playerDataStore.playTagRoom: playerDataStore.playTagRoom(), itemType: .roomId)
//}
