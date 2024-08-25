//
//  InviteViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/24.
//

import SwiftUI

struct InviteViewCell: View {
    @Binding var friend: User
    
    var body: some View {
        HStack {
            if let iconImage = getIconImage() {
                Image(uiImage: iconImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
            } else {
                Image(systemName: "person.circle")
                    .foregroundStyle(Color.accentColor)
                    .font(.system(size: 40.0))
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
    }
    func getIconImage() -> UIImage? {
        if let iconData = friend.iconData {
            return UIImage(data: iconData)
        } else {
            return nil
        }
    }
}

//#Preview {
//    InviteViewCell()
//}
