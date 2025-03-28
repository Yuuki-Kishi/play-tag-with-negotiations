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
            Text(playerRankText())
                .foregroundStyle(playerRankTextColor())
                .font(.system(size: 150))
                .frame(height: UIScreen.main.bounds.height * 0.2)
            List {
                Section(content: {
                    ForEach(playerDataStore.playerArray.playing, id: \.playerUserId) { player in
                        ResultViewCell(playerDataStore: playerDataStore, player: Binding(get: { player }, set: {_ in}))
                    }
                }, header: {
                    Text("ランキング")
                })
                Section(content: {
                    ForEach(playerDataStore.playerArray.notPlaying, id: \.playerUserId) { player in
                        ResultViewCell(playerDataStore: playerDataStore, player: Binding(get: { player }, set: {_ in}))
                    }
                }, header: {
                    Text("ゲーム離脱者")
                })
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    Task { await UserRepository.finishGame() }
                    pathDataStore.navigatetionPath.removeAll()
                }, label: {
                    Text("確認")
                })
            })
        }
        .navigationTitle("結果")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onDisappear() {
            clearDataStore()
        }
    }
    func playerRank() -> Int {
        var playingPlayers = playerDataStore.playerArray.filter { $0.isPlaying }
        playingPlayers.sort { $0.point > $1.point }
        guard let index = playingPlayers.firstIndex(where: { $0.isMe }) else { return playingPlayers.count }
        return index + 1
    }
    func playerRankText() -> String {
        if !playerDataStore.playerArray.me.isPlaying {
            return "N/A"
        }
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
        if !playerDataStore.playerArray.me.isPlaying {
            return .primary
        }
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
    func clearDataStore() {
        userDataStore.listeners.remove(listenerType: .friendShips)
        userDataStore.listeners.remove(listenerType: .myUserData)
        userDataStore.listeners.remove(listenerType: .players)
        playerDataStore.playingRoom = PlayTagRoom()
    }
}

#Preview {
    ResultView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
