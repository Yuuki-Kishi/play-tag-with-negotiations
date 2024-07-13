//
//  FriendDataStore.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import Foundation

class FriendDataStore: ObservableObject {
    static let shared = FriendDataStore()
    @Published var notFriendArray: [User] = []
    @Published var friendArray: [User] = []
}
