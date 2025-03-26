//
//  NotRankResultViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/26.
//

import SwiftUI

struct NotRankResultViewCell: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    @Binding var player: Player
    @State private var isShowAlert = false
    
    var body: some View {
        HStack {
            Text(user().userName)
                .frame(alignment: .leading)
                .font(.system(size: 20))
                .foregroundStyle(userNameColor())
                .lineLimit(1)
            Spacer()
            Image(systemName: isChaserIcon())
                .foregroundStyle(iconColor())
                .font(.system(size: 25))
            Text(String(player.point) + "pt")
                .font(.system(size: 25))
                .foregroundStyle(Color.primary)
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
    func userNameColor() -> Color {
        var color = Color.primary
        if player.isMe {
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
    func isDisplayButton() -> Bool {
        let isFriend = FriendShipRepository.isExists(pertnerUserId: player.playerUserId)
        if !isFriend && !player.isMe { return true }
        return false
    }
}

//#Preview {
//    NotRankResultViewCell(playerDataStore: PlayerDataStore.shared, player: Player())
//}
