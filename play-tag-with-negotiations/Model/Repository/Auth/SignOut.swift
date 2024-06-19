//
//  SignOut.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import Foundation
import FirebaseAuth

class SignOut {
    static func signOut() {
        do {
            try Auth.auth().signOut()
            UserDataStore.shared.signInUser = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
