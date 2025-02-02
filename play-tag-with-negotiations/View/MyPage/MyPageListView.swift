//
//  MyPageCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/17.
//

import SwiftUI

struct MyPageListView: View {
    @ObservedObject var userDataStore: UserDataStore
    @State private var text = ""
    @State private var isShowUserNameAlert = false
    @State private var isShowUserIdAlert = false
    @State private var isShowPronounAlert = false
    
    var body: some View {
        List {
            HStack {
                Text("ユーザーネーム")
                    .frame(alignment: .leading)
                Spacer()
                Text(userDataStore.signInUser?.userName ?? "不明なユーザー")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(Color.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if userDataStore.signInUser?.userName != "未設定" {
                    text = userDataStore.signInUser?.userName ?? ""
                } else {
                    text = ""
                }
                isShowUserNameAlert = true
            }
            .alert("ユーザーネームを変更", isPresented: $isShowUserNameAlert, actions: {
                TextField("ユーザーネーム", text: $text)
                Button(role: .cancel, action: {}, label: {
                    Text("キャンセル")
                })
                Button("変更", action: {
                    Task {
                        await UserRepository.updateUserName(newName: text)
                    }
                })
            })
            HStack {
                Text("ユーザーID")
                    .frame(alignment: .leading)
                Spacer()
                Text(userDataStore.signInUser?.userId ?? "不明なユーザーID")
                    .font(.system(size: 13))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(Color.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIPasteboard.general.string = userDataStore.signInUser?.userId
                isShowUserIdAlert = true
            }
            .alert("コピーしました", isPresented: $isShowUserIdAlert, actions: {
                Button(action: {}, label: {
                    Text("OK")
                })
            }, message: {
                Text("ユーザーIDをクリップボードにコピーしました。")
            })
            HStack {
                Text("アカウント作成日")
                Spacer()
                Text(dateToString(date: userDataStore.signInUser?.creationDate))
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 13))
            }
            VStack {
                Text("自己紹介")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                ScrollView {
                    Text(userDataStore.signInUser?.profile ?? "")
                        .foregroundStyle(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .contentShape(Rectangle())
            .frame(maxHeight: UIScreen.main.bounds.height / 3)
            .onTapGesture {
                if userDataStore.signInUser?.profile != "未設定" {
                    text = userDataStore.signInUser?.profile ?? ""
                } else {
                    text = ""
                }
                isShowPronounAlert = true
            }
            .alert("代名詞を変更", isPresented: $isShowPronounAlert, actions: {
                TextField("代名詞", text: $text)
                Button(role: .cancel, action: {}, label: {
                    Text("キャンセル")
                })
                Button("変更", action: {
                    Task {
                        await UserRepository.updateprofile(newProfile: text)
                    }
                })
            }, message: {
                Text("代名詞を入力してください。")
            })
        }
    }
    func dateToString(date: Date?) -> String {
        guard let creationDate = date else { return "不明" }
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateformatter.string(from: creationDate)
    }
}

#Preview {
    MyPageListView(userDataStore: UserDataStore.shared)
}
