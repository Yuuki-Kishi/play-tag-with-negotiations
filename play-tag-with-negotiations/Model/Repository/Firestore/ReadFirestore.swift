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
            guard let userName = document["userName"] as? String else { return User() }
            guard let creationDate = Auth.auth().currentUser?.metadata.creationDate else { return User() }
            let iconUrl = document["iconUrl"] as? String ?? ""
            guard let pronoun = document["pronoun"] as? String else { return User() }
            return User(userId: userId, userName: userName, creationDate: creationDate, iconUrl: iconUrl, pronoun: pronoun)
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
            let playTagRoom = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).getDocument()
            guard let roomIdString = playTagRoom["roomId"] as? String else { return PlayTagRoom() }
            guard let roomId = UUID(uuidString: roomIdString) else { return PlayTagRoom() }
            guard let hostUserId = playTagRoom["hostUserId"] as? String else { return PlayTagRoom() }
            guard let playTagName = playTagRoom["playTagName"] as? String else { return PlayTagRoom() }
            guard let creationTimestamp = playTagRoom["creationDate"] as? Timestamp else { return PlayTagRoom() }
            guard let phaseNow = playTagRoom["phaseNow"] as? Int else { return PlayTagRoom() }
            guard let phaseMax = playTagRoom["phaseMax"] as? Int else { return PlayTagRoom() }
            guard let chaserNumber = playTagRoom["chaserNumber"] as? Int else { return PlayTagRoom() }
            guard let fugitiveNumber = playTagRoom["fugitiveNumber"] as? Int else { return PlayTagRoom() }
            guard let horizontalCount = playTagRoom["horizontalCount"] as? Int else { return PlayTagRoom() }
            guard let verticalCount = playTagRoom["verticalCount"] as? Int else { return PlayTagRoom() }
            guard let isPublic = playTagRoom["isPublic"] as? Bool else { return PlayTagRoom() }
            guard let isCanJoinAfter = playTagRoom["isCanJoinAfter"] as? Bool else { return PlayTagRoom() }
            guard let isNegotiate = playTagRoom["isNegotiate"] as? Bool else { return PlayTagRoom() }
            guard let isCanDoQuest = playTagRoom["isCanDoQuest"] as? Bool else { return PlayTagRoom() }
            guard let isCanUseItem = playTagRoom["isCanUseItem"] as? Bool else { return PlayTagRoom() }
            return PlayTagRoom(roomId: roomId, hostUserId: hostUserId, playTagName: playTagName, creationDate: creationTimestamp.dateValue(), players: [], phaseNow: phaseNow, phaseMax: phaseMax, chaserNumber: chaserNumber, fugitiveNumber: fugitiveNumber, horizontalCount: horizontalCount, verticalCount: verticalCount, isPublic: isPublic, isCanJoinAfter: isCanJoinAfter, isNegotiate: isNegotiate, isCanDoQuest: isCanDoQuest, isCanUseItem: isCanUseItem)
        } catch {
            print(error)
        }
        return PlayTagRoom()
    }
}
