//
//  NotFriendViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import SwiftUI

struct NotFriendViewCell: View {
    @Binding var friend: User
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
        .onTapGesture {
            isShowAlert = true
        }
        .alert("フレンド申請を承認しますか？", isPresented: $isShowAlert, actions: {
            Button(role: .destructive, action: {
                Task {
                    await DeleteToFirestore.deleteFriend(friendUserId: friend.userId)
                }
            }, label: {
                Text("削除")
            })
            Button(role: .cancel, action: {
                Task {
                    await UpdateToFirestore.becomeFriend(friendUserId: friend.userId)
                }
            }, label: {
                Text("承認")
            })
        })
    }
}

//#Preview {
//    NotFriendViewCell(friend: User())
//}
