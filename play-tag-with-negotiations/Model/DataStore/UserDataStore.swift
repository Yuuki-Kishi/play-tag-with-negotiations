//
//  UserData.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/16.
//

import Foundation
import FirebaseFirestore

class UserDataStore: ObservableObject {
    static let shared = UserDataStore()
    @Published var userResult: Result<User?, Error>? = nil
    @Published var signInUser: User? = nil
    @Published var displayControlPanel: controlPanelMode = .movement
    @Published var noticeArray: [Notice] = []
    @Published var fightRecordArray: [PlayedRoom] = []
    @Published var listeners: [listenerType: ListenerRegistration] = [:]
    enum controlPanelMode {
        case movement
        case deal(Deal)
        case playerInfo(PlayerInfo)
        enum Deal {
            case client, negotiation
        }
        enum PlayerInfo {
            case players, info
        }
    }
    enum listenerType: CaseIterable {
        case myUserData, usersData, roomField, phaseNow, notice, players, publicRooms, friendShips, negotiation, deal
    }
    
    func cleanUpListeners() {
        for listenerType in listenerType.allCases {
            listeners.remove(listenerType: listenerType)
        }
    }
}
