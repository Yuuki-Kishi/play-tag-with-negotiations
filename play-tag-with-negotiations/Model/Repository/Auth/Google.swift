//
//  GoogleAuth.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/16.
//

import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class Google {
    static func handleSignInButton() {
        guard let clientID: String = FirebaseApp.app()?.options.clientID else { return }
        let config:GIDConfiguration = GIDConfiguration(clientID: clientID)
        let windowScene:UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController:UIViewController? = windowScene?.windows.first!.rootViewController!
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController!) { result, error in
            guard error == nil else {
                print("GIDSignInError: \(error!.localizedDescription)")
                return
            }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
            self.login(credential: credential)
        }
    }
    
    static func reauthenticateAndDeleteUser() {
        guard let clientID: String = FirebaseApp.app()?.options.clientID else { return }
        let config:GIDConfiguration = GIDConfiguration(clientID: clientID)
        let windowScene:UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController:UIViewController? = windowScene?.windows.first!.rootViewController!
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController!) { result, error in
            guard error == nil else {
                print("GIDSignInError: \(error!.localizedDescription)")
                return
            }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
            Auth.auth().currentUser?.reauthenticate(with: credential) { _, error  in
                if let error = error {
                    print("reauthenticateError: \(error.localizedDescription)")
                    return
                }
                AuthRepository.deleteUser()
            }
        }
    }
    
    static func login(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            Task {
                if let error = error {
                    print("SignInError: \(error.localizedDescription)")
                    return
                }
                guard let userId = authResult?.user.uid else { return }
                guard let creationDate = authResult?.user.metadata.creationDate else { return }
                let user = User(userId: userId, creationDate: creationDate, signInType: .google)
                if await !UserRepository.isExists(userId: userId) {
                    await UserRepository.createUser(user: user)
                } else {
                    await UserRepository.updateSignInType(user: user)
                }
                DispatchQueue.main.async {
                    UserDataStore.shared.userResult = .success(user)
                    UserDataStore.shared.signInUser = user
                }
            }
        }
    }
}
