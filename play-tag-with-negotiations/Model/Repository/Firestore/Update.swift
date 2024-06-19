//
//  Update.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/19.
//

import Foundation
import FirebaseFirestore

class Update {
    static func updateUserName(newName: String) {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        Firestore.firestore().collection("Users").document(userId).setData(["userName": newName], merge: true)
    }
    
    static func updatePronoun(newPronoun: String) {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        Firestore.firestore().collection("Users").document(userId).setData(["pronoun": newPronoun], merge: true)
    }
}
