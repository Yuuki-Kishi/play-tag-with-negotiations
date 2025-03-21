//
//  TutorialMovePanelViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialFieldMapViewCell: View {
    @StateObject var userDataStore = UserDataStore.shared
    @ObservedObject var tutorialDataStore: TutorialDataStore
    @State var num: Int
    
    var body: some View {
        switch numToPlayers().count {
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
            return height * 0.8 / CGFloat(tutorialDataStore.tutorialPlayTagRoom.horizontalCount)
        } else {
            return width * 0.8 / CGFloat(tutorialDataStore.tutorialPlayTagRoom.horizontalCount)
        }
    }
    func numToPlayers() -> [Player] {
        let x = num % tutorialDataStore.tutorialPlayTagRoom.horizontalCount
        let y = num / tutorialDataStore.tutorialPlayTagRoom.horizontalCount
        let playerPosition = PlayerPosition(x: x, y: y)
        var players: [Player] = []
        for player in tutorialDataStore.tutorialPlayerArray {
            if let position = player.move.first {
                if position == playerPosition { players.append(player) }
            }  else {
                continue
            }
        }
        return players
    }
}

#Preview {
    TutorialFieldMapViewCell(tutorialDataStore: TutorialDataStore.shared, num: 0)
}
