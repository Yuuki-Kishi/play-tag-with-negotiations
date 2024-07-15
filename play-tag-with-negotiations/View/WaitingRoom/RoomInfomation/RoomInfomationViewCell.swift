//
//  RoomInfomationCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/06.
//

import SwiftUI

struct RoomInfomationViewCell: View {
    @State var playTagRoom: PlayTagRoom
    @State var itemType: PlayTagRoom.displayItemType
    @State private var isShowAlert = false
    
    var body: some View {
        switch itemType {
        case .roomId:
            uuidCell(item: "ルームID", data: playTagRoom.roomId.uuidString)
        case .hostUserId:
            stringCell(item: "ホストユーザーID", data: playTagRoom.hostUserId)
        case .playTagName:
            stringCell(item: "鬼ごっこ名", data: playTagRoom.playTagName)
        case .creationDate:
            dateCell(item: "作成日時", data: playTagRoom.creationDate)
        case .phaseNow:
            intCell(item: "現在のフェーズ", data: playTagRoom.phaseNow)
        case .phaseMax:
            intCell(item: "最大フェーズ", data: playTagRoom.phaseMax)
        case .chaserNumber:
            intCell(item: "鬼の人数", data: playTagRoom.chaserNumber)
        case .fugitiveNumber:
            intCell(item: "逃走者の人数", data: playTagRoom.fugitiveNumber)
        case .horizontalCount:
            intCell(item: "横のマスの数", data: playTagRoom.horizontalCount)
        case .verticalCount:
            intCell(item: "縦のマスの数", data: playTagRoom.verticalCount)
        case .isPublic:
            boolCell(item: "公開", data: playTagRoom.isPublic)
        case .isCanJoinAfter:
            boolCell(item: "途中参加", data: playTagRoom.isCanJoinAfter)
        case .isNegotiate:
            boolCell(item: "交渉", data: playTagRoom.isNegotiate)
        case .isCanDoQuest:
            boolCell(item: "クエスト", data: playTagRoom.isCanDoQuest)
        case .isCanUseItem:
            boolCell(item: "アイテム", data: playTagRoom.isCanUseItem)
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
            isShowAlert = true
        }
        .alert("コピーしました", isPresented: $isShowAlert, actions: {
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
                .frame(alignment: .leading)
            Spacer()
            Text(data)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .foregroundStyle(Color.gray)
        }
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
    }
    func boolCell(item: String, data: Bool) -> some View {
        HStack {
            Text(item)
                .frame(maxWidth: .infinity, alignment: .leading)
            if data {
                Image(systemName: "checkmark.square.fill")
                    .foregroundStyle(Color.gray)
                    .frame(alignment: .trailing)
            } else {
                Image(systemName: "square")
                    .foregroundStyle(Color.gray)
                    .frame(alignment: .trailing)
            }
        }
    }
    func dateToString(date: Date) -> String {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFomatter.string(from: date)
    }
}

//#Preview {
//    RoomInfomationViewCell(playTagRoom: PlayTagRoom(), itemType: .roomId)
//}
