//
//  TutorialRoomSettingViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialRoomSettingViewCell: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    @State var itemType: PlayTagRoom.displayItemType
    
    var body: some View {
        switch itemType {
        case .roomId:
            stringCell(item: "ルームID", data: tutorialDataStore.tutorialPlayTagRoom.roomId)
        case .hostUserId:
            stringCell(item: "ホストユーザーID", data: tutorialDataStore.tutorialPlayTagRoom.hostUserId)
        case .playTagName:
            stringCell(item: "鬼ごっこ名", data: tutorialDataStore.tutorialPlayTagRoom.playTagName)
        case .creationDate:
            dateCell(item: "作成日時", data: tutorialDataStore.tutorialPlayTagRoom.creationDate)
        case .phaseMax:
            intCell(item: "最大フェーズ", data: tutorialDataStore.tutorialPlayTagRoom.phaseMax)
        case .chaserNumber:
            intCell(item: "鬼の人数", data: tutorialDataStore.tutorialPlayTagRoom.chaserNumber)
        case .fugitiveNumber:
            intCell(item: "逃走者の人数", data: tutorialDataStore.tutorialPlayTagRoom.fugitiveNumber)
        case .horizontalCount:
            intCell(item: "横のマスの数", data: tutorialDataStore.tutorialPlayTagRoom.horizontalCount)
        case .verticalCount:
            intCell(item: "縦のマスの数", data: tutorialDataStore.tutorialPlayTagRoom.verticalCount)
        case .isPublic:
            Toggle("公開", isOn: $tutorialDataStore.tutorialPlayTagRoom.isPublic)
                .disabled(true)
        case .isCanJoinAfter:
            Toggle("途中参加", isOn: $tutorialDataStore.tutorialPlayTagRoom.isCanJoinAfter)
                .disabled(true)
        case .isDeal:
            Toggle("交渉", isOn: $tutorialDataStore.tutorialPlayTagRoom.isDeal)
                .disabled(true)
        }
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

#Preview {
    TutorialRoomSettingViewCell(tutorialDataStore: TutorialDataStore.shared, itemType: .roomId)
}
