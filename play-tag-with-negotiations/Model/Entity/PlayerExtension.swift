//
//  PlayerExtension.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/10.
//

import Foundation

extension Player {
    var isMe: Bool {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return false }
        if self.playerUserId == myUserId { return true }
        return false
    }
}
