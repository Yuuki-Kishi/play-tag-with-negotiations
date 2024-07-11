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
            UserDataStore.shared.signInUser = await ReadToFirestore.getUserData(userId: currentUser.uid)
        }
    }
}
