//
//  Read.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import Foundation
import FirebaseFirestore

class Check {
    static func isWroteUser(userId: String) async -> Bool {
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            if document.exists { return true }
        } catch {
            print("Error getting document: \(error)")
            return true
        }
        return false
    }
    
    static func isBeingRoom(roomId: String) async -> Bool {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return true }
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).getDocument()
            if !document.exists { return false }
        } catch {
            print(error)
        }
        return true
    }
    
    static func checkRecieveRequest(from: String) async -> Bool {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return false }
        do {
            let document = try await Firestore.firestore().collection("Users").document(myUserId).collection("Friends").document(from).getDocument()
            if document.exists { return true }
        } catch {
            print(error)
        }
        return false
    }
    
    static func checkIsThereRoom(roomId: String) async -> Bool {
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).getDocument()
            if document.exists { return true }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    static func checkNotOverPlayerCount(roomId: String) async -> Bool {
        do {
            let playersCount = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").getDocuments().count
            guard let playTagRoom = await Get.getRoomData(roomId: roomId) else { return false }
            let limit = playTagRoom.chaserNumber + playTagRoom.fugitiveNumber
            if playersCount < limit { return true }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    static func checkDeals(phaseNow: Int) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let myDeals = PlayerDataStore.shared.dealArray.filter { $0.proposerUserId == myUserId && $0.condition != .fulfilled }
        for myDeal in myDeals {
            if myDeal.expiredPhase <= phaseNow {
                await Fulfill.fulfillDeal(deal: myDeal)
            }
        }
    }
}
