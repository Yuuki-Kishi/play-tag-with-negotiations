//
//  FieldMapViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/22.
//

import SwiftUI

struct FieldMapViewCell: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @State var num: Int
    
    var body: some View {
        switch numToPlayerCount(num: num) {
        case 0:
            noIcon()
        case 1:
            singleIcon()
        default :
            multiIcon()
        }
    }
    func noIcon() -> some View {
        Rectangle()
            .frame(width: squareSize(), height: squareSize())
            .foregroundStyle(Color(UIColor.systemGray5))
    }
    func singleIcon() -> some View {
        Group {
            if let player = numToPlayers(num: num).first {
                if player.isChaser {
                    singleChaserIcon(player: player)
                } else {
                    singlefugitiverIcon(player: player)
                }
            } else {
                Image(systemName: "person.crop.circle.badge.questionmark")
                    .resizable()
                    .resizable()
                    .foregroundStyle(Color.red)
                    .frame(width: squareSize(), height: squareSize())
                    .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
            }
        }
    }
    func singleChaserIcon(player: Player) -> some View {
        if player.playerUserId == userDataStore.signInUser?.userId {
            return Image(systemName: "figure.run.circle.fill")
                .resizable()
                .resizable()
                .foregroundStyle(Color.red)
                .frame(width: squareSize(), height: squareSize())
                .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
        } else {
            return Image(systemName: "figure.run.circle")
                .resizable()
                .resizable()
                .foregroundStyle(Color.red)
                .frame(width: squareSize(), height: squareSize())
                .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
        }
    }
    func singlefugitiverIcon(player: Player) -> some View {
        if player.playerUserId == userDataStore.signInUser?.userId {
            return Image(systemName: "figure.walk.circle.fill")
                .resizable()
                .foregroundStyle(Color.blue)
                .frame(width: squareSize(), height: squareSize())
                .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
        } else {
            return Image(systemName: "figure.walk.circle")
                .resizable()
                .foregroundStyle(Color.blue)
                .frame(width: squareSize(), height: squareSize())
                .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
        }
    }
    func multiIcon() -> some View {
        let chasers = numToPlayers(num: num).filter({ $0.isChaser })
        let fugitives = numToPlayers(num: num).filter({ !$0.isChaser })
        if chasers.isEmpty && !fugitives.isEmpty {
            if fugitives.contains(where: { $0.playerUserId == userDataStore.signInUser?.userId }) {
                return Image(systemName: "person.2.circle.fill")
                    .resizable()
                    .foregroundStyle(Color.blue)
                    .frame(width: squareSize(), height: squareSize())
                    .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
            } else {
                return Image(systemName: "person.2.circle")
                    .resizable()
                    .foregroundStyle(Color.blue)
                    .frame(width: squareSize(), height: squareSize())
                    .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
            }
        } else if fugitives.isEmpty && !chasers.isEmpty {
            if fugitives.contains(where: { $0.playerUserId == userDataStore.signInUser?.userId }) {
                return Image(systemName: "person.2.circle.fill")
                    .resizable()
                    .foregroundStyle(Color.red)
                    .frame(width: squareSize(), height: squareSize())
                    .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
            } else {
                return Image(systemName: "person.2.circle")
                    .resizable()
                    .foregroundStyle(Color.red)
                    .frame(width: squareSize(), height: squareSize())
                    .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
            }
        } else {
            if fugitives.contains(where: { $0.playerUserId == userDataStore.signInUser?.userId }) {
                return Image(systemName: "person.2.circle.fill")
                    .resizable()
                    .foregroundStyle(Color.purple)
                    .frame(width: squareSize(), height: squareSize())
                    .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
            } else {
                return Image(systemName: "person.2.circle")
                    .resizable()
                    .foregroundStyle(Color.purple)
                    .frame(width: squareSize(), height: squareSize())
                    .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
            }
        }
    }
    func squareSize() -> CGFloat {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height * 0.6
        if width > height {
            return height * 0.8 / CGFloat(playerDataStore.playingRoom.horizontalCount)
        } else {
            return width * 0.8 / CGFloat(playerDataStore.playingRoom.horizontalCount)
        }
    }
    func numToPlayers(num: Int) -> [Player] {
        let x = num % playerDataStore.playingRoom.horizontalCount
        let y = num / playerDataStore.playingRoom.horizontalCount
        let playerPosition = PlayerPosition(x: x, y: y)
        let players = playerDataStore.playerArray.filter { $0.move.last == playerPosition && !$0.isCaptured }
        return players
    }
    func numToPlayerCount(num: Int) -> Int {
        let players = numToPlayers(num: num)
        return players.count
    }
}

//#Preview {
//    FieldMapViewCell(players: [])
//}
