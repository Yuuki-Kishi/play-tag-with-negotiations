//
//  WaitingRoomCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/17.
//

import SwiftUI

struct WaitingRoomViewCell: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @Binding var userId: String
    @State private var isShowAlert = false
    
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
                Text(user().userName)
                    .foregroundStyle(userNameColor())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25))
                Text(user().profile)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .font(.system(size: 15))
            }
        }
    }
    func userNameColor() -> Color {
        var color = Color.primary
        if user().userId == userDataStore.signInUser?.userId {
            color = Color.green
        }
        return color
    }
    func getIconImage() -> UIImage? {
        if let iconData = user().iconData {
            return UIImage(data: iconData)
        } else {
            return nil
        }
    }
    func user() -> User {
        guard let user = playerDataStore.userArray.first(where: { $0.userId == userId }) else { return User() }
        return user
    }
}

//#Preview {
//    WaitingRoomViewCell(user: User())
//}
