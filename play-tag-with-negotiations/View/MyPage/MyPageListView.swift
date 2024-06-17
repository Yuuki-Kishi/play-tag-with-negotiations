//
//  MyPageCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/17.
//

import SwiftUI

struct MyPageListView: View {
    @ObservedObject var userDataStore: UserDataStore
    
    var body: some View {
        List {
            HStack {
                Text("ユーザーネーム")
                    .frame(alignment: .leading)
                Spacer()
                Text(userDataStore.signInUser?.userName ?? "不明なユーザー")
                    .lineLimit(1)
                    .frame(width: .infinity, alignment: .trailing)
                    .foregroundStyle(Color.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                
            }
            HStack {
                Text("ユーザーID")
                    .frame(alignment: .leading)
                Spacer()
                Text(userDataStore.signInUser?.userId ?? "不明なユーザーID")
                    .lineLimit(1)
                    .frame(width: .infinity, alignment: .trailing)
                    .foregroundStyle(Color.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                
            }
            VStack {
                Text("ひとこと")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                ScrollView {
                    Text(userDataStore.signInUser?.onePhrase ?? "")
                        .foregroundStyle(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .contentShape(Rectangle())
            .frame(maxHeight: UIScreen.main.bounds.height / 3)
            .onTapGesture {
                
            }
        }
    }
}

#Preview {
    MyPageListView(userDataStore: UserDataStore.shared)
}
