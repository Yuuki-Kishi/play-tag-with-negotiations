//
//  FightRecordViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/28.
//

import SwiftUI

struct FightRecordViewCell: View {
    @Binding var playedRoom: PlayedRoom
    
    var body: some View {
        HStack {
            Text(playerRankText())
                .font(.system(size: 40))
                .frame(width: 70)
                .foregroundStyle(playerRankTextColor())
            VStack {
                Text(playedRoom.playTagName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20))
                Text(creationDateText())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 10))
            }
            Text(String(playedRoom.players.me.point + 100) + "pt")
                .font(.system(size: 20))
                .frame(width: 60, alignment: .trailing)
            Image(systemName: isChaserIcon())
                .foregroundStyle(iconColor())
                .font(.system(size: 25))
        }
    }
    func playerRank() -> Int {
        var playingPlayers = playedRoom.players.filter { $0.isPlaying }
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
        if playedRoom.players.me.isChaser {
            return "figure.run.circle"
        } else {
            return "figure.walk.circle"
        }
    }
    func iconColor() -> Color {
        if playedRoom.players.me.isChaser {
            return .red
        } else {
            return .blue
        }
    }
    func creationDateText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: playedRoom.creationDate)
    }
}

//#Preview {
//    FightRecordViewCell(playedRoom: Binding(get: { PlayedRoom()}, set: {_ in}))
//}
