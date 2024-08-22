//
//  CheckSignIn.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/09.
//

import Foundation
import FirebaseAuth

class CheckSignIn {
    static func isSignIn() async {
        if let currentUser = Auth.auth().currentUser {
            let user = await ReadToFirestore.getUserData(userId: currentUser.uid)
            DispatchQueue.main.async {
                UserDataStore.shared.userResult = .success(user)
                UserDataStore.shared.signInUser = user
            }
        } else {
            DispatchQueue.main.async {
                UserDataStore.shared.userResult = .success(nil)
                UserDataStore.shared.signInUser = nil
            }
        }
    }
}
