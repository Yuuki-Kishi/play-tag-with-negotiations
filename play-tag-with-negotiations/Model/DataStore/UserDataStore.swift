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
    @Published var listeners: [listenerType: ListenerRegistration] = [:]
    enum controlPanelMode {
        case movement
        case deal(Deal)
        case quest(Quest)
//        case item
        enum Deal {
            case target, negotiation
        }
        enum Quest {
            case target, mission
        }
    }
    enum listenerType {
        case userData, roomField, notice, players, myPropaty, isDecided, publicRooms, friend, negotiation, deal
    }
}
