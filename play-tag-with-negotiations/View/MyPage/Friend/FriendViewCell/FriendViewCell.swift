//
//  FriendViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import SwiftUI

struct FriendViewCell: View {
    @State var friend: User
    @State private var isShowAlert = false
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .font(.system(size: 50.0))
                .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
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
                    await DeleteToFirestore.deleteFriend(friendUserId: friend.userId)
                }
            }, label: {
                Text("解消")
            })
        })
    }
}

//#Preview {
//    FriendViewCell(friend: User())
//}
