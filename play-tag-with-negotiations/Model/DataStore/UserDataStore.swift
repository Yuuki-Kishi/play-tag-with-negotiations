//
//  UserData.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/16.
//

import Foundation

class UserDataStore: ObservableObject {
    static let shared = UserDataStore()
    @Published var signInUser: User? = nil
    @Published var beingRoom: PlayTagRoom? = nil
}
