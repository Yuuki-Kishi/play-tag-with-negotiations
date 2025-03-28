//
//  PlayerInfoView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/02/12.
//

import SwiftUI

struct PlayerInfoView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        if playerDataStore.selectedPlayer.playerUserId == "unknownUserId" {
            VStack {
                Text("情報を見るプレイヤーを指定してください")
                Text("マップ上のアイコンをタップしてください")
            }
        } else {
            VStack {
                HStack {
                    if let iconImage = getIconImage() {
                        Image(uiImage: iconImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .font(.system(size: 60.0))
                            .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                            .padding(.horizontal, 20)
                    } else {
                        Image(systemName: "person.circle")
                            .foregroundStyle(Color.accentColor)
                            .font(.system(size: 60.0))
                            .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                            .padding(.horizontal, 20)
                    }
                    VStack {
                        Text(user().userName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 30))
                        Text(user().profile)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                            .font(.system(size: 15))
                    }
                    Button(action: {
                        selectClear()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.gray)
                    })
                }
                HStack {
                    Text(playerRankText())
                        .foregroundStyle(playerRankTextColor())
                        .font(.system(size: 59).bold())
                        .padding(.horizontal)
                    Text(String(playerDataStore.selectedPlayer.point) + "pt")
                        .font(.system(size: 50))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Image(systemName: isChaserIcon())
                        .resizable()
                        .foregroundStyle(iconColor())
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.horizontal)
        }
    }
    func getIconImage() -> UIImage? {
        if let iconData = user().iconData {
            return UIImage(data: iconData)
        } else {
            return nil
        }
    }
    func user() -> User {
        guard let user = playerDataStore.userArray.first(where: { $0.userId == playerDataStore.selectedPlayer.playerUserId }) else { return User() }
        return user
    }
    func playerRank() -> Int {
        var playingPlayers = playerDataStore.playerArray.filter { $0.isPlaying }
        playingPlayers.sort { $0.point > $1.point }
        guard let index = playingPlayers.firstIndex(where: { $0.isMe }) else { return playingPlayers.count }
        return index + 1
    }
    func playerRankText() -> String {
        let rank = playerRank()
        switch rank {
        case 1:
            return String(rank) + "st"
        case 2:
            return String(rank) + "nd"
        case 3:
            return String(rank) + "rd"
        default:
            return String(rank) + "th"
        }
    }
    func playerRankTextColor() -> Color {
        switch playerRank() {
        case 1:
            return Color.pink
        case 2:
            return Color.mint
        case 3:
            return Color.orange
        default:
            return Color.indigo
        }
    }
    func isChaserIcon() -> String {
        if playerDataStore.selectedPlayer.isChaser {
            if playerDataStore.selectedPlayer.isMe {
                return "figure.run.circle.fill"
            } else {
                return "figure.run.circle"
            }
        } else {
            if playerDataStore.selectedPlayer.isMe {
                return "figure.walk.circle.fill"
            } else {
                return "figure.walk.circle"
            }
        }
    }
    func iconColor() -> Color {
        if playerDataStore.selectedPlayer.isChaser {
            return .red
        } else {
            return .blue
        }
    }
    func selectClear() {
        playerDataStore.selectedPlayers = playerDataStore.playerArray
        userDataStore.displayControlPanel = .playerInfo(.players)
        playerDataStore.selectedPlayer = Player()
    }
}

#Preview {
    PlayerInfoView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
