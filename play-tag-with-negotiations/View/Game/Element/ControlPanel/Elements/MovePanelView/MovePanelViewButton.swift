//
//  MovePanelViewButton.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/27.
//

import SwiftUI

struct MovePanelViewButton: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @State var direction: directions
    enum directions {
        case leftUp, up, rightUp, left, stay, right, leftDowm, dowm, rightDown
    }
    
    var body: some View {
        Button(action: {
            move()
        }, label: {
            Image(systemName: imageName())
                .resizable()
                .foregroundStyle(buttonColor())
                .aspectRatio(contentMode: .fit)
        })
    }
    func move() {
        let isDecided = playerDataStore.player.isDecided
        let isCaptured = playerDataStore.player.isCaptured
        if !isDecided && !isCaptured {
            Task {
                let playerPosition = calculateCoordinate()
                let x = playerPosition.x
                let y = playerPosition.y
                await UpdateToFirestore.updatePosition(x: x, y: y)
            }
        }
    }
    func imageName() -> String {
        switch direction {
        case .leftUp:
            if isCanDisplay() {
                return "arrow.up.left.square.fill"
            } else {
                return ""
            }
        case .up:
            if isCanDisplay() {
                return "arrow.up.square.fill"
            } else {
                return ""
            }
        case .rightUp:
            if isCanDisplay() {
                return "arrow.up.right.square.fill"
            } else {
                return ""
            }
        case .left:
            if isCanDisplay() {
                return "arrow.left.square.fill"
            } else {
                return ""
            }
        case .stay:
            if isCanDisplay() {
                return "octagon.fill"
            } else {
                return ""
            }
        case .right:
            if isCanDisplay() {
                return "arrow.right.square.fill"
            } else {
                return ""
            }
        case .leftDowm:
            if isCanDisplay() {
                return "arrow.down.left.square.fill"
            } else {
                return ""
            }
        case .dowm:
            if isCanDisplay() {
                return "arrow.down.square.fill"
            } else {
                return ""
            }
        case .rightDown:
            if isCanDisplay() {
                return "arrow.down.right.square.fill"
            } else {
                return ""
            }
        }
    }
    func isCanDisplay() -> Bool {
        guard let x = playerDataStore.player.move.last?.x else { return false }
        guard let y = playerDataStore.player.move.last?.y else { return false }
        let horizontalCount = playerDataStore.playingRoom.horizontalCount
        let verticalCount = playerDataStore.playingRoom.verticalCount
        switch direction {
        case .leftUp:
            if x > 0 && y > 0 {
                return true
            } else {
                return false
            }
        case .up:
            if y > 0 {
                return true
            } else {
                return false
            }
        case .rightUp:
            if x < horizontalCount - 1 && y > 0 {
                return true
            } else {
                return false
            }
        case .left:
            if x > 0 {
                return true
            } else {
                return false
            }
        case .stay:
            return true
        case .right:
            if x < horizontalCount - 1 {
                return true
            } else {
                return false
            }
        case .leftDowm:
            if x > 0 && y < verticalCount - 1 {
                return true
            } else {
                return false
            }
        case .dowm:
            if y < verticalCount - 1 {
                return true
            } else {
                return false
            }
        case .rightDown:
            if x < horizontalCount - 1 && y < verticalCount - 1 {
                return true
            } else {
                return false
            }
        }
    }
    func calculateCoordinate() -> PlayerPosition {
        guard var x = playerDataStore.player.move.last?.x else { return PlayerPosition() }
        guard var y = playerDataStore.player.move.last?.y else { return PlayerPosition() }
        switch direction {
        case .leftUp:
            x -= 1
            y -= 1
        case .up:
            y -= 1
        case .rightUp:
            x += 1
            y -= 1
        case .left:
            x -= 1
        case .stay:
            break
        case .right:
            x += 1
        case .leftDowm:
            x -= 1
            y += 1
        case .dowm:
            y += 1
        case .rightDown:
            x += 1
            y += 1
        }
        return PlayerPosition(x: x, y: y)
    }
    func buttonColor() -> Color {
        let isDecided = playerDataStore.player.isDecided
        let isCaptured = playerDataStore.player.isCaptured
        if isCaptured {
            return .gray
        } else {
            if isDecided {
                return .gray
            } else {
                return .accentColor
            }
        }
    }
}

#Preview {
    MovePanelViewButton(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, direction: .leftUp)
}
