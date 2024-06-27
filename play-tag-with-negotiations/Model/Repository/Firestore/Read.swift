//
//  Read.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import Foundation
import FirebaseFirestore

class Read {
    static func isWriteUserName() async -> Bool {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return false }
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            return document["userName"] == nil ? true : false
        } catch {
            print("Error getting document: \(error)")
            return false
        }
    }
    
    static func isWritePronoun() async -> Bool {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return false }
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            return document["pronoun"] == nil ? true : false
        } catch {
            print("Error getting document: \(error)")
            return false
        }
    }
    
    static func getRoomCount(isPublic: Bool) async -> Int {
        do {
            if isPublic {
                let document = try await Firestore.firestore().collection("PlayTagRooms").document("PlayTagRooms").collection("PublicRooms").document("PublicRooms").getDocument()
                guard let roomCount = document["RoomCount"] as? Int else { return -1 }
                return roomCount
            } else {
                let document = try await Firestore.firestore().collection("PlayTagRooms").document("PlayTagRooms").collection("PrivateRooms").document("PrivateRooms").getDocument()
                guard let roomCount = document["RoomCount"] as? Int else { return -1 }
                return roomCount
            }
        } catch {
            print("Error getting document: \(error)")
            return -1
        }
    }
}
