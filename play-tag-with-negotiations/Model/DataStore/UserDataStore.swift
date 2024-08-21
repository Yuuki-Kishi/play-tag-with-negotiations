//
//  UserData.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/16.
//

import Foundation
import FirebaseAuth

class UserDataStore: ObservableObject {
    static let shared = UserDataStore()
    @Published var userResult: Result<User?, Error>? = nil
    @Published var signInUser: User? = nil
    @Published var displayControlPanel: controlPanelMode = .movement
    @Published var noticeArray: [Notice] = []
    enum controlPanelMode {
        case movement, negotiation
    }
}
