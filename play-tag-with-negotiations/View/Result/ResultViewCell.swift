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
    
    var body: some View {
        HStack {
            Text(playerRankText())
                .font(.system(size: 25))
                .frame(width: 50)
                .foregroundStyle(playerRankTextColor())
            Text(playerToUser().userName)
                .frame(alignment: .leading)
                .font(.system(size: 20))
                .foregroundStyle(userNameColor())
            Spacer()
            Image(systemName: isChaserIcon())
                .font(.system(size: 25))
            Text(String(player.point) + "pt")
                .font(.system(size: 25))
                .frame(width: 60)
                .foregroundStyle(Color.primary)
        }
    }
    func playerRank() -> Int {
        guard let index = playerDataStore.playerArray.firstIndex(where: { $0.userId == player.userId }) else { return playerDataStore.playerArray.count }
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
    func playerToUser() -> User {
        guard let user = playerDataStore.userArray.first(where: { $0.userId == player.userId }) else { return User() }
        return user
    }
    func userNameColor() -> Color {
        var color = Color.primary
        if playerToUser().userId == userDataStore.signInUser?.userId {
            color = Color.green
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
}

//#Preview {
//    ResultViewCell(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
//}
