//
//  ResultView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/10.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @ObservedObject var pathDataStore: PathDataStore
    
    var body: some View {
        VStack {
            Spacer()
            Text(playerRankText(player: playerDataStore.player))
                .foregroundStyle(playerRankTextColor(player: playerDataStore.player))
                .font(.system(size: 150))
                .frame(height: UIScreen.main.bounds.height * 0.2)
            List($playerDataStore.playerArray) { player in
                ResultViewCell(userDataStore: userDataStore, rankText: playerRankText(player: player.wrappedValue), rankTextColor: playerRankTextColor(player: player.wrappedValue), user: playerToUser(player: player.wrappedValue), player: player)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    Task {
                        await DeleteToFirestore.endGame()
                    }
                    pathDataStore.navigatetionPath.removeAll()
                }, label: {
                    Text("確認")
                })
            })
        }
        .onAppear() {
            Task {
                await ReadToFirestore.getResult()
            }
        }
        .navigationTitle("結果")
        .navigationBarBackButtonHidden()
    }
    func playerRank(player: Player) -> Int {
        guard let index = playerDataStore.playerArray.firstIndex(where: { $0.userId == player.userId }) else { return playerDataStore.playerArray.count }
        return index + 1
    }
    func playerRankText(player: Player) -> String {
        let rank = playerRank(player: player)
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
    func playerRankTextColor(player: Player) -> Color {
        let rank = playerRank(player: player)
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
    func playerToUser(player: Player) -> User {
        guard let user = playerDataStore.userArray.first(where: { $0.userId == player.userId }) else { return User() }
        return user
    }
}

#Preview {
    ResultView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
