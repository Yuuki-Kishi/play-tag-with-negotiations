//
//  ResultViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/10.
//

import SwiftUI

struct RankResultViewCell: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    @Binding var player: Player
    @State private var isShowAlert = false
    
    var body: some View {
        HStack {
            Text(playerRankText())
                .font(.system(size: 40))
                .frame(width: 70)
                .foregroundStyle(playerRankTextColor())
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
                HStack {
                    Text(String(player.point) + "pt")
                        .font(.system(size: 15))
                        .frame(width: 60)
                        .foregroundStyle(Color.primary)
                    Image(systemName: isChaserIcon())
                        .foregroundStyle(iconColor())
                        .font(.system(size: 25))
                    Spacer()
                }
            }
            if isDisplayButton() {
                Button(action: {
                    Task {
                        await FriendShipRepository.sendFriendRequest(consenter: player.playerUserId)
                        isShowAlert = true
                    }
                }, label: {
                    Image(systemName: "paperplane.fill")
                })
                .buttonStyle(.plain)
                .frame(width: 30)
                .foregroundStyle(Color.accentColor)
                .alert("フレンド申請を送信しました", isPresented: $isShowAlert, actions: {
                    Button(action: {}, label: {
                        Text("OK")
                    })
                })
            } else {
                Button(action: {}, label: {
                    Image(systemName: "paperplane.fill")
                })
                .buttonStyle(.plain)
                .frame(width: 30)
                .foregroundStyle(Color.clear)
            }
        }
    }
    func playerRank() -> Int {
        guard let index = playerDataStore.playerArray.firstIndex(where: { $0.playerUserId == player.playerUserId }) else { return playerDataStore.playerArray.count }
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
        let rank = playerRank()
        switch rank {
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
    func userNameColor() -> Color {
        var color = Color.primary
        if player.isMe {
            color = .green
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
    func isChaserIcon() -> String {
        if player.isChaser {
            return "figure.run.circle"
        } else {
            return "figure.walk.circle"
        }
    }
    func iconColor() -> Color {
        if player.isChaser {
            return .red
        } else {
            return .blue
        }
    }
    func user() -> User {
        guard let user = playerDataStore.userArray.first(where: { $0.userId == player.playerUserId }) else { return User() }
        return user
    }
    func isDisplayButton() -> Bool {
        let isFriend = FriendShipRepository.isExists(pertnerUserId: player.playerUserId)
        if !isFriend && !player.isMe { return true }
        return false
    }
}

//#Preview {
//    RankResultViewCell(playerDataStore: PlayerDataStore.shared, player: Player())
//}
