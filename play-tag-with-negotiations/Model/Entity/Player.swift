//
//  Player.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import Foundation
import SwiftUI

class Player: Identifiable {
    var id = UUID()
    var user: User
    var x: Int
    var y: Int
    
    init(user: User, x: Int, y: Int) {
        self.id = UUID()
        self.user = user
        self.x = x
        self.y = y
    }
}
