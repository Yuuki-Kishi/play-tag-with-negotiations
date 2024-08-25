//
//  NotFriendViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import SwiftUI

struct NotFriendViewCell: View {
    @Binding var friend: User
    @State private var icon: UIImage? = nil
    @State private var isShowBeFriendAlert = false
    @State private var isShowDeleteFirendAlert = false
    
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
                isShowDeleteFirendAlert = true
            }, label: {
                Text("削除")
            })
        }
        .tint(Color.red)
        .onTapGesture {
            isShowBeFriendAlert = true
        }
        .alert("フレンド申請を承認しますか？", isPresented: $isShowBeFriendAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(action: {
                Task {
                    await UpdateToFirestore.becomeFriend(friendUserId: friend.userId)
                }
            }, label: {
                Text("承認")
            })
        })
        .alert("フレンド申請を削除しますか？", isPresented: $isShowDeleteFirendAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                Task {
                    await DeleteToFirestore.deleteFriend(friendUserId: friend.userId)
                }
            }, label: {
                Text("削除")
            })
        })
        .onAppear() {
            getIcon()
        }
    }
    func getIcon() {
        if friend.iconUrl != "default" {
            Task {
                guard let imageData = await ReadToStorage.getIconImage(iconUrl: friend.iconUrl) else { return }
                icon = UIImage(data: imageData)
            }
        }
    }
}

//#Preview {
//    NotFriendViewCell(friend: User())
//}
