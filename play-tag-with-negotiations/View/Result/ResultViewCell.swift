//
//  ResultViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/10.
//

import SwiftUI

struct ResultViewCell: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @Binding var player: Player
    @State private var isShowAlert = false
    
    var body: some View {
        HStack {
            Text(playerRankText())
                .font(.system(size: 25))
                .frame(width: 50)
                .foregroundStyle(playerRankTextColor())
            Text(user().userName)
                .frame(alignment: .leading)
                .font(.system(size: 20))
                .foregroundStyle(userNameColor())
            Spacer()
            Image(systemName: isChaserIcon())
                .foregroundStyle(iconColor())
                .font(.system(size: 25))
            Text(String(player.point) + "pt")
                .font(.system(size: 25))
                .foregroundStyle(Color.primary)
            if !FriendShipRepository.isExists(pertnerUserId: player.playerUserId) {
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
        if player.playerUserId == userDataStore.signInUser?.userId {
            color = .green
        }
        return color
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
}

//#Preview {
//    ResultViewCell(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, player: Player())
//}
