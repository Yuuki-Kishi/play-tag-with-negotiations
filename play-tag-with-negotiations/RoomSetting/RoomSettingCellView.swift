//
//  RoomSettingCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/11.
//

import SwiftUI

struct RoomSettingCellView: View {
    @State private var itemElement: String
    @State private var stringDataElement: String
    @State private var boolDataElement: Bool
    @State private var itemType: RoomSettingCellView.itemTypeEnum
    @State private var text = ""
    @State private var isShowCopiedAlert = false
    @State private var isShowStringAlert = false
    @State private var isShowIntAlert = false
    enum itemTypeEnum { case UUID, String, Int, Bool }
    
    init(itemElement: String, stringDataElement: String, itemType: RoomSettingCellView.itemTypeEnum) {
        self.itemElement = itemElement
        self.stringDataElement = stringDataElement
        self.boolDataElement = false
        self.itemType = itemType
    }
    
    init(itemElement: String, boolDataElement: Bool, itemType: RoomSettingCellView.itemTypeEnum) {
        self.itemElement = itemElement
        self.stringDataElement = "nil"
        self.boolDataElement = boolDataElement
        self.itemType = itemType
    }
    
    var body: some View {
        switch itemType {
        case .UUID:
            HStack {
                Text(itemElement)
                    .frame(alignment: .leading)
                Spacer()
                Text(stringDataElement)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .lineLimit(1)
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 12))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIPasteboard.general.string = stringDataElement
                isShowCopiedAlert = true
            }
            .alert("ルームIDをコピーしました", isPresented: $isShowCopiedAlert, actions: {
                Button(action: {
                    isShowCopiedAlert = false
                }, label: {
                    Text("OK")
                })
            })
        case .String:
            HStack {
                Text(itemElement)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(stringDataElement)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .lineLimit(1)
                    .foregroundStyle(Color.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                text = ""
                isShowStringAlert = true
            }
            .alert(itemElement + "を変更", isPresented: $isShowStringAlert, actions: {
                TextField(itemElement, text: $text)
                Button("キャンセル", role: .cancel, action: {})
                Button("変更", action: {
                    stringDataElement = text
                    isShowStringAlert = false
                })
            })
        case .Int:
            HStack {
                Text(itemElement)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(stringDataElement)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .lineLimit(1)
                    .foregroundStyle(Color.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                text = ""
                isShowIntAlert = true
            }
            .alert(itemElement + "を変更", isPresented: $isShowIntAlert, actions: {
                TextField(itemElement, text: $text)
                Button("キャンセル", role: .cancel, action: {})
                Button("変更", action: {
                    stringDataElement = checkTextIsNumber(before: stringDataElement, after: text)
                    isShowStringAlert = false
                })
            })
        case .Bool:
            Toggle(itemElement, isOn: $boolDataElement)
        }
    }
    func checkTextIsNumber(before: String, after: String) -> String {
        let range = 0...9
        var numberArray = [String]()
        if let text = Int(after) {
            let charArray = Array(arrayLiteral: text)
            for char in charArray {
                if range.contains(char) {
                    numberArray.append(String(char))
                }
            }
            return numberArray.joined()
        }
        return before
    }
}

#Preview {
    RoomSettingCellView(itemElement: "item", stringDataElement: "data", itemType: .String)
}
