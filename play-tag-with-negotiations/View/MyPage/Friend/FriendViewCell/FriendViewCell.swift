//
//  FriendViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import SwiftUI

struct FriendViewCell: View {
    @Binding var friendShip: FriendShip
    
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
    }
    func iconImage() -> UIImage? {
        guard let iconData = friendShip.pertnerUser.iconData else { return nil }
        return UIImage(data: iconData)
    }
}

//#Preview {
//    FriendViewCell(friend: User())
//}
