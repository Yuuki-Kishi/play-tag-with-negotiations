//
//  ApplyingViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/01/24.
//

import SwiftUI

struct ApplyingViewCell: View {
    @Binding var friendShip: FriendShip
    @State private var isShowAlert = false
    
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
                Text(friendShip.pertnerUser.userName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25))
                Text(friendShip.pertnerUser.profile)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .font(.system(size: 15))
            }
        }
        .onTapGesture {
            isShowAlert = true
        }
        .alert("フレンド申請を削除しますか？", isPresented: $isShowAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                Task {
                    await FriendShipRepository.deleteFriend(pertnerUserId: friendShip.pertnerUser.userId)
                }
            }, label: {
                Text("削除")
            })
        })
    }
    func iconImage() -> UIImage? {
        guard let iconData = friendShip.pertnerUser.iconData else { return nil }
        return UIImage(data: iconData)
    }
}

//#Preview {
//    ApplyingViewCell()
//}
