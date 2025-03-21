//
//  TutorialDataStore.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import Foundation

@MainActor
class TutorialDataStore: ObservableObject {
    static let shared = TutorialDataStore()
    @Published var tutorialDisplayControlPanel: UserDataStore.controlPanelMode = .movement
    @Published var tutorialPlayTagRoom: PlayTagRoom = PlayTagRoom()
    @Published var tutorialUserArray: [User] = []
    @Published var tutorialPlayerArray: [Player] = []
    @Published var tutorialSelectetPlayer = Player()
    @Published var tutorialNegotiationArray: [Negotiation] = []
    @Published var tutorialDealArray: [Deal] = []
    
    func initPlayTagRoom() {
        var playTagRoom = PlayTagRoom(playTagName: "チュートリアル")
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        playTagRoom.hostUserId = myUserId
        playTagRoom.playerNumber = 4
        DispatchQueue.main.async {
            self.tutorialPlayTagRoom = playTagRoom
        }
    }
    
    func initUserArrayAndPlayerArray() {
        for i in 0 ..< 3 {
            var user = User()
            user.userId = UUID().uuidString
            user.userName = "プレイヤー" + String(i + 1)
            user.profile = "I am player" + String(i + 1)
            let player = Player(playerUserId: user.userId, isHost: false)
            DispatchQueue.main.async {
                self.tutorialUserArray.append(noDuplicate: user)
                self.tutorialPlayerArray.append(noDuplicate: player)
            }
        }
    }
    
    func initPosition() {
        for i in 0 ..< 4 {
            var player = tutorialPlayerArray[i]
            if player.isMe { player.isChaser = true }
            let horizontalCount = self.tutorialPlayTagRoom.horizontalCount
            let verticalCount = self.tutorialPlayTagRoom.verticalCount
            let initialX = Int.random(in: 0 ..< horizontalCount)
            let initialY = Int.random(in: 0 ..< verticalCount)
            player.move.append(PlayerPosition(phase: 1, x: initialX, y: initialY))
            DispatchQueue.main.async {
                self.tutorialPlayerArray.append(noDuplicate: player)
            }
        }
    }
    
    func updateMyPosition(newPosition: PlayerPosition) {
        let me = tutorialPlayerArray.me
        var new = me
        new.move = [newPosition]
        self.tutorialPlayerArray.append(noDuplicate: new)
    }
    
    func initNegotiationArrayAndDealArray() {
        let changePosition = Negotiation(negotiationId: UUID().uuidString, negotiationName: .changePosition, displayName: "場所を入替", target: .both, iconName: "arrow.trianglehead.2.clockwise.rotate.90.circle.fill", version: 1.0)
        let freezeOnce = Negotiation(negotiationId: UUID().uuidString, negotiationName: .freezeOnce, displayName: "静止させる", target: .both, iconName: "figure.walk.diamond.fill", version: 1.0)
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let deal = Deal(negotiationId: changePosition.negotiationId, proposerUserId: tutorialSelectetPlayer.playerUserId, clientUserId: myUserId, period: 1, consideration: 20)
        tutorialNegotiationArray.append(noDuplicate: changePosition)
        tutorialNegotiationArray.append(noDuplicate: freezeOnce)
        tutorialDealArray.append(noDuplicate: deal)
    }
}
