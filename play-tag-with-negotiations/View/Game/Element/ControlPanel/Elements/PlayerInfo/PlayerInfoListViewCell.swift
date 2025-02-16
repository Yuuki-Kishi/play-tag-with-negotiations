//
//  PlayerListView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/02/16.
//

import SwiftUI

struct PlayerInfoListViewCell: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @Binding var player: Player
    
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
                    .font(.system(size: 50.0))
                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
            }
            VStack {
                Text(user().userName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25))
                Text(user().profile)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .font(.system(size: 15))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard let player = playerDataStore.playerArray.first(where: { $0.playerUserId == user().userId }) else { return }
            playerDataStore.selectedPlayer = player
            withAnimation {
                userDataStore.displayControlPanel = .playerInfo(.info)
            }
        }
    }
    func user() -> User {
        guard let user = playerDataStore.userArray.first(where: { $0.userId == player.playerUserId }) else { return User() }
        return user
    }
    func getIconImage() -> UIImage? {
        if let iconData = user().iconData {
            return UIImage(data: iconData)
        } else {
            return nil
        }
    }
}

//#Preview {
//    PlayerInfoListViewCell(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, player: Player())
//}
