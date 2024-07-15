//
//  FriendDataStore.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import Foundation
import OrderedCollections

class FriendDataStore: ObservableObject {
    static let shared = FriendDataStore()
    @Published var friendArray: [User] = []
    @Published var requestUserArray: [User] = []
}
