//
//  TimerRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/02.
//

import Foundation

class TimerDataStore {
    static let shared = TimerDataStore()
    
    private var timer: Timer?
    
    func setTimer(limit: Int) {
        timer?.invalidate()
        DispatchQueue.main.async {
            PlayerDataStore.shared.countDownTimer = limit
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(coundDown), userInfo: nil, repeats: true)
    }
    
    @objc func coundDown() {
        if PlayerDataStore.shared.countDownTimer > 0 {
            DispatchQueue.main.async {
                PlayerDataStore.shared.countDownTimer -= 1
            }
        } else {
            timer?.invalidate()
            let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
            guard let playerPosition = PlayerDataStore.shared.playerArray.me.move.last else { return }
            Task {
                await PlayerRepository.grantMePoint(howMany: 20)
                await PlayerPositionRepository.updateMyPosition(phase: phaseNow + 1, x: playerPosition.x, y: playerPosition.y)
            }
        }
    }
    
    func invalidate() {
        timer?.invalidate()
    }
}
