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
        switch numToPlayers().filter({ !$0.isCaptured }).count {
        case 0:
            noIcon()
        case 1:
            singleIcon()
                .onTapGesture {
                    switch userDataStore.displayControlPanel {
                    case .movement:
                        break
                    case .deal(.client):
                        guard let player = numToPlayers().first else { return }
                        playerDataStore.selectedPlayers = []
                        playerDataStore.selectedPlayer = player
                        userDataStore.displayControlPanel = .deal(.negotiation)
                    case .deal(.negotiation):
                        guard let player = numToPlayers().first else { return }
                        playerDataStore.selectedPlayers = []
                        playerDataStore.selectedPlayer = player
                        userDataStore.displayControlPanel = .deal(.negotiation)
                    case .playerInfo(.players):
                        guard let player = numToPlayers().first else { return }
                        playerDataStore.selectedPlayers = []
                        playerDataStore.selectedPlayer = player
                        userDataStore.displayControlPanel = .playerInfo(.info)
                    case .playerInfo(.info):
                        guard let player = numToPlayers().first else { return }
                        playerDataStore.selectedPlayers = []
                        playerDataStore.selectedPlayer = player
                        userDataStore.displayControlPanel = .playerInfo(.info)
                    }
                }
        default :
            multiIcon()
                .onTapGesture {
                    switch userDataStore.displayControlPanel {
                    case .movement:
                        break
                    case .deal(.client):
                        playerDataStore.selectedPlayers = numToPlayers().filter({ !$0.isCaptured })
                        playerDataStore.selectedPlayer = Player()
                        userDataStore.displayControlPanel = .deal(.client)
                    case .deal(.negotiation):
                        playerDataStore.selectedPlayers = numToPlayers().filter({ !$0.isCaptured })
                        playerDataStore.selectedPlayer = Player()
                        userDataStore.displayControlPanel = .deal(.client)
                    case .playerInfo(.players):
                        playerDataStore.selectedPlayers = numToPlayers().filter({ !$0.isCaptured })
                        playerDataStore.selectedPlayer = Player()
                        userDataStore.displayControlPanel = .playerInfo(.players)
                    case .playerInfo(.info):
                        playerDataStore.selectedPlayers = numToPlayers().filter({ !$0.isCaptured })
                        playerDataStore.selectedPlayer = Player()
                        userDataStore.displayControlPanel = .playerInfo(.players)
                    }
                }
        }
    }
    func noIcon() -> some View {
        Rectangle()
            .frame(width: squareSize(), height: squareSize())
            .foregroundStyle(Color(UIColor.systemGray5))
    }
    func singleIcon() -> some View {
        Group {
            if let player = numToPlayers().filter({ !$0.isCaptured }).first {
                if player.isChaser {
                    singleChaserIcon(player: player)
                } else {
                    singlefugitiverIcon(player: player)
                }
            } else {
                Image(systemName: "person.crop.circle.badge.questionmark")
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
                .foregroundStyle(Color.red)
                .frame(width: squareSize(), height: squareSize())
                .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
        } else {
            return Image(systemName: "figure.run.circle")
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
        let chasers = numToPlayers().filter({ $0.isChaser })
        let fugitives = numToPlayers().filter({ !$0.isChaser })
        let isContainFugitive = fugitives.contains(where: { $0.playerUserId == userDataStore.signInUser?.userId })
        let isContainChaser = chasers.contains(where: { $0.playerUserId == userDataStore.signInUser?.userId })
        if chasers.isEmpty && !fugitives.isEmpty {
            if isContainFugitive {
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
            if isContainChaser {
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
            if isContainFugitive || isContainChaser {
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
    func numToPlayers() -> [Player] {
        let x = num % playerDataStore.playingRoom.horizontalCount
        let y = num / playerDataStore.playingRoom.horizontalCount
        let playerPosition = PlayerPosition(x: x, y: y)
        var players: [Player] = []
        let phaseNow = playerDataStore.playingRoom.phaseNow
        for player in playerDataStore.playerArray {
            if let position = player.move.first(where: { $0.phase == phaseNow }) {
                if position == playerPosition && player.isPlaying { players.append(player) }
            }  else {
                if let lastPosition = player.move.last {
                    if lastPosition == playerPosition && player.isPlaying { players.append(player) }
                } else {
                    continue
                }
            }
        }
        return players
    }
    func userName() -> String {
        guard let playerUserId = numToPlayers().first?.playerUserId else { return "" }
        guard let user = playerDataStore.userArray.first(where: { $0.userId == playerUserId }) else { return "" }
        return user.userName
    }
}

//#Preview {
//    FieldMapViewCell(players: [])
//}
