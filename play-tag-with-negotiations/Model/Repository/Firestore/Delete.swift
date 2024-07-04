//
//  Delete.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/04.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class Delete {
    static func exitRoom(roomId: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).delete()
        } catch {
            print(error)
        }
    }
    
    static func deleteRoom(roomId: String) async {
        do {
            try await Firestore.firestore().collection("PlayTagRoom").document(roomId).delete()
        } catch {
            print(error)
        }
    }
}
