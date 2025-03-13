//
//  ResultView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/10.
//

import SwiftUI
import TipKit

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
            TipView(FriendShipTip())
                .padding(.horizontal)
            List($playerDataStore.playerArray) { player in
                ResultViewCell(userDataStore: userDataStore, playerDataStore: playerDataStore, player: player)
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
        let me = PlayerDataStore.shared.playerArray.me
        DispatchQueue.main.async {
            PlayerDataStore.shared.playerArray.sort { $0.point > $1.point }
        }
        guard let index = PlayerDataStore.shared.playerArray.firstIndex(where: { $0.playerUserId == me.playerUserId }) else { return PlayerDataStore.shared.playerArray.count }
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
    func clearDataStore() {
        userDataStore.listeners.remove(listenerType: .playersPropaty)
        userDataStore.listeners.remove(listenerType: .friendShips)
        userDataStore.listeners.remove(listenerType: .userData)
        playerDataStore.playingRoom = PlayTagRoom()
        playerDataStore.selectedPlayers = []
        playerDataStore.userArray.removeAll()
        playerDataStore.playerArray.removeAll()
        playerDataStore.dealArray.removeAll()
        playerDataStore.negotiationArray.removeAll()
    }
}

#Preview {
    ResultView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
