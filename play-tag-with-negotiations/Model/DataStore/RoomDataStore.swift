//
//  RoomDataStore.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/09.
//

import Foundation

class RoomDataStore: ObservableObject {
    static let shared = RoomDataStore()
    @Published var publicRoomsArray: [PlayTagRoom] = []
}
