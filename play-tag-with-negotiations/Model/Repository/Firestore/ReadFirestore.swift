//
//  Read.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ReadToFirestore {
    static func isWroteUser(userId: String) async -> Bool {
        do {
            let userDocuments = try await Firestore.firestore().collection("Users").whereField("userId", isEqualTo: userId).getDocuments()
            for userDocument in userDocuments.documents {
                if userDocument.documentID == userId { return true }
            }
            return false
        } catch {
            print("Error getting document: \(error)")
            return true
        }
    }
    
    static func isBeingRoom(roomId: String) async -> Bool {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return true }
        do {
            let players = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").whereField("userId", isEqualTo: userId).getDocuments()
            if players.isEmpty { return false }
        } catch {
            print(error)
        }
        return true
    }
    
    static func getUserData(userId: String) async -> User {
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            let user = try document.data(as: User.self)
            return user
        } catch {
            print(error)
            return User()
        }
    }
    
    static func checkIsThereRoom(roomId: String) async -> Bool {
        do {
            let playTagRooms = try await Firestore.firestore().collection("PlayTagRooms").getDocuments()
            for playTagRoom in playTagRooms.documents {
                if playTagRoom.documentID == roomId { return true }
            }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    static func getRoomData(roomId: String) async -> PlayTagRoom {
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).getDocument()
            let playTagRoom = try document.data(as: PlayTagRoom.self)
            return playTagRoom
        } catch {
            print(error)
        }
        return PlayTagRoom()
    }
}
