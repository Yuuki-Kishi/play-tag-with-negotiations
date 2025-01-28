//
//  NotFriendViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import SwiftUI

struct PendingViewCell: View {
    @Binding var friendShip: FriendShip
    @State var friend: User
    @State private var isShowBeFriendAlert = false
    @State private var isShowDeleteFirendAlert = false
    
    var body: some View {
        HStack {
            if let iconImage = iconImage() {
                Image(uiImage: iconImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
            } else {
                Image(systemName: "person.circle")
                    .foregroundStyle(Color.accentColor)
                    .font(.system(size: 50.0))
                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
            }
            VStack {
                Text(friend.userName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25))
                Text(friend.profile)
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
                    await FriendShipRepository.becomeFriend(consenter: friend.userId)
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
                    await FriendShipRepository.deleteFriend(friendShipId: friendShip.friendShipId, pertnerUserId: friend.userId)
                }
            }, label: {
                Text("削除")
            })
        })
    }
    func iconImage() -> UIImage? {
        guard let iconData = friend.iconData else { return nil }
        return UIImage(data: iconData)
    }
}

//#Preview {
//    NotFriendViewCell(friend: User())
//}
