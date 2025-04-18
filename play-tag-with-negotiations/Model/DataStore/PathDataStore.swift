//
//  EnvironmentData.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/10.
//

import Foundation
import SwiftUI

class PathDataStore: ObservableObject {
    static let shared = PathDataStore()
    @Published var navigatetionPath: [path] = []
    
    enum path {
        case tutorial, tutorialPublicRooms, tutorialRoomSetting, tutorialWaitingRoom, tutorialGame, TutorialResult, fightRecord, roomSetting, notice, myPage, friend, waitingRoom, roomInfo, invite, game, result, deleteUser
    }
}
