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
    @State var players: [Player]
    
    var body: some View {
        switch players.count {
        case 0:
            noIcon()
                .onAppear() {
                    print(players.count)
                }
        case 1:
            singleIcon()
                .onAppear() {
                    print(players.count)
                }
        default :
            multiIcon()
                .onAppear() {
                    print(players.count)
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
            if let player = players.first {
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
        if player.userId == userDataStore.signInUser?.userId {
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
        if player.userId == userDataStore.signInUser?.userId {
            return Image(systemName: "figure.walk.circle.fill")
                .resizable()
                .foregroundStyle(Color.red)
                .frame(width: squareSize(), height: squareSize())
                .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
        } else {
            return Image(systemName: "figure.walk.circle")
                .resizable()
                .foregroundStyle(Color.red)
                .frame(width: squareSize(), height: squareSize())
                .background(Rectangle().foregroundStyle(Color(UIColor.systemGray5)))
        }
    }
    func multiIcon() -> some View {
        let chasers = players.filter({ $0.isChaser })
        let fugitives = players.filter({ !$0.isChaser })
        if chasers.isEmpty && !fugitives.isEmpty {
            if fugitives.contains(where: { $0.userId == userDataStore.signInUser?.userId }) {
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
            if fugitives.contains(where: { $0.userId == userDataStore.signInUser?.userId }) {
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
            if fugitives.contains(where: { $0.userId == userDataStore.signInUser?.userId }) {
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
}

//#Preview {
//    FieldMapViewCell(players: [])
//}
