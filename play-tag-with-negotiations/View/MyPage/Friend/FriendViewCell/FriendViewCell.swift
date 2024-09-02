//
//  FriendViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import SwiftUI

struct FriendViewCell: View {
    @Binding var friend: User
    @State private var icon: UIImage? = nil
    @State private var isShowAlert = false
    
    var body: some View {
        HStack {
            if let iconImage = icon {
                Image(uiImage: iconImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
            } else {
                Image(systemName: "person")
                    .font(.system(size: 50.0))
                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
            }
            VStack {
                Text(friend.userName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25))
                Text(friend.pronoun)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .font(.system(size: 15))
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(action: {
                isShowAlert = true
            }, label: {
                Text("解消")
            })
        }
        .tint(Color.red)
        .alert("フレンドを解消しますか？", isPresented: $isShowAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                Task {
                    await Delete.deleteFriend(friendUserId: friend.userId)
                }
            }, label: {
                Text("解消")
            })
        })
        .onAppear() {
            getIcon()
        }
    }
    func getIcon() {
        if friend.iconUrl != "default" {
            Task {
                guard let imageData = await Download.getIconImage(iconUrl: friend.iconUrl) else { return }
                icon = UIImage(data: imageData)
            }
        }
    }
}

//#Preview {
//    FriendViewCell(friend: User())
//}
