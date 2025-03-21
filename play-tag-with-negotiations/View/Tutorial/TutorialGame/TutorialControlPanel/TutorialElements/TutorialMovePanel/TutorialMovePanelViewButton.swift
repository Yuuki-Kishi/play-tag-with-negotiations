//
//  TutorialMovePanelViewButton.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialMovePanelViewButton: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    @State var direction: directions
    enum directions {
        case leftUp, up, rightUp, left, stay, right, leftDowm, dowm, rightDown
    }
    
    var body: some View {
        Button(action: {
            tutorialDataStore.tutorialPlayTagRoom.phaseNow += 1
            tutorialDataStore.updateMyPosition(newPosition: calculateCoordinate())
            if tutorialDataStore.tutorialPlayTagRoom.phaseNow >= tutorialDataStore.tutorialPlayTagRoom.phaseMax {
                tutorialDataStore.tutorialPlayTagRoom.isFinished = true
            }
        }, label: {
            Image(systemName: imageName())
                .resizable()
                .foregroundStyle(.accent)
                .aspectRatio(contentMode: .fit)
        })
    }
    func imageName() -> String {
        switch direction {
        case .leftUp:
            return "arrow.up.left.square.fill"
        case .up:
            return "arrow.up.square.fill"
        case .rightUp:
            return "arrow.up.right.square.fill"
        case .left:
            return "arrow.left.square.fill"
        case .stay:
            return "octagon.fill"
        case .right:
            return "arrow.right.square.fill"
        case .leftDowm:
            return "arrow.down.left.square.fill"
        case .dowm:
            return "arrow.down.square.fill"
        case .rightDown:
            return "arrow.down.right.square.fill"
        }
    }
    func isCanDisplay() -> Bool {
        guard let x = tutorialDataStore.tutorialPlayerArray.me.move.last?.x else { return false }
        guard let y = tutorialDataStore.tutorialPlayerArray.me.move.last?.y else { return false }
        let horizontalCount = tutorialDataStore.tutorialPlayTagRoom.horizontalCount
        let verticalCount = tutorialDataStore.tutorialPlayTagRoom.verticalCount
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
        guard var x = tutorialDataStore.tutorialPlayerArray.me.move.last?.x else { return PlayerPosition() }
        guard var y = tutorialDataStore.tutorialPlayerArray.me.move.last?.y else { return PlayerPosition() }
        let phaseNow = tutorialDataStore.tutorialPlayTagRoom.phaseNow
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
        return PlayerPosition(phase: phaseNow, x: x, y: y)
    }
}

//#Preview {
//    TutorialMovePanelViewButton(tutorialDataStore: TutorialDataStore.shared, direction: .leftUp)
//}
