//
//  CheckSignIn.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/09.
//

import Foundation
import FirebaseAuth
import AuthenticationServices

class AuthRepository {
//check
    static func isSignIn() async {
        if let currentUser = Auth.auth().currentUser {
            let user = await UserRepository.getUserData(userId: currentUser.uid)
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
    
//delete
    static func signOut() {
        do {
            try Auth.auth().signOut()
            UserDataStore.shared.signInUser = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    static func reauthenticateAndDeleteUser() {
        guard let signInType = UserDataStore.shared.signInUser?.signInType else { return }
        switch signInType {
        case .google:
            Google.reauthenticateAndDeleteUser()
        case .apple:
            Apple.reauthenticateAndDeleteUser()
        case .unknown:
            break
        }
    }
    
    static func deleteUser() {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("DeleteError: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                PathDataStore.shared.navigatetionPath.removeAll()
                UserDataStore.shared.userResult = .success(nil)
                UserDataStore.shared.signInUser = nil
            }
        }
    }
}
