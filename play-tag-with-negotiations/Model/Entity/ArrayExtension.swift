//
//  Array.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/14.
//

import Foundation
import FirebaseFirestore

extension Array where Element == User {
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(where: { $0.userId == item.userId }) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    
    mutating func user(userId: String) -> Element {
        guard let user = self.first(where: { $0.userId == userId }) else { return User() }
        return user
    }
    
    mutating func remove(userId: String) {
        guard let index = self.firstIndex(where: { $0.userId == userId }) else { return }
        self.remove(at: index)
    }
}

extension Array where Element == FriendShip {
    var friends: [Element] {
        return self.filter { $0.status == .accepted }
    }
    
    var pendings: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        return self.filter { $0.status == .pending && $0.consenterUserId == myUserId }
    }
    
    var applyings: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        return self.filter { $0.status == .pending && $0.proposerUserId == myUserId }
    }
    
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(of: item) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    
    mutating func remove(friendShip: FriendShip) {
        guard let index = self.firstIndex(of: friendShip) else { return }
        self.remove(at: index)
    }
}

extension Array where Element == Player {
    var me: Element {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return Player() }
        guard let me = self.first(where: { $0.playerUserId == myUserId }) else { return Player() }
        return me
    }
    
    var host: Element {
        guard let host = self.first(where: { $0.isHost }) else { return Player() }
        return host
    }
    
    var isHost: Bool {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return false }
        guard let host = self.first(where: { $0.isHost }) else { return false }
        if host.playerUserId == myUserId { return true }
        return false
    }
    
    var users: [User] {
        var users: [User] = []
        for player in self {
            guard let user = PlayerDataStore.shared.userArray.first(where: { $0.userId == player.playerUserId }) else { return [] }
            users.append(user)
        }
        return users
    }
    
    var guests: [Element] {
        return self.filter { !$0.isHost }
    }
    
    var guestUsers: [User] {
        let guests = self.guests
        return guests.users
    }
    
    var playing: [Element] {
        return self.filter { $0.isPlaying }
    }
    
    var notPlaying: [Element] {
        return self.filter { !$0.isPlaying }
    }
    
    var isAllDecided: Bool {
        if self.filter({ $0.isDecided }).count == self.count {
            return true
        }
        return false
    }
    
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(where: { $0.playerUserId == item.playerUserId }) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    
    mutating func remove(userId: String) {
        guard let index = firstIndex(where: { $0.playerUserId == userId }) else { return }
        self.remove(at: index)
    }
}

extension Array where Element == PlayerPosition {
    var determinePosition: Element? {
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        if let position = self.first(where: { $0.phase ==  phaseNow }) {
            return position
        } else {
            if let lastPosition = self.filter({ $0.phase <= phaseNow }).last {
                return lastPosition
            } else {
                return nil
            }
        }
    }
}

extension Array where Element == Notice {
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(where: { $0.noticeId == item.noticeId }) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
}

extension Array where Element == Negotiation {
    var canPropose: [Element] {
        let deals = PlayerDataStore.shared.dealArray.proposing + PlayerDataStore.shared.dealArray.success + PlayerDataStore.shared.dealArray.proposed
        let negotiations = deals.map { $0.negotiationId }
        let forChasers = self.filter { $0.target == .chaser }
        let forFugitives = self.filter { $0.target == .fugitive }
        let allPlayers = self.filter { $0.target == .both }
        var canProposes: [Element] = []
        if PlayerDataStore.shared.playerArray.me.isChaser {
            canProposes = forChasers + allPlayers
        } else {
            canProposes = forFugitives + allPlayers
        }
        let returns = canProposes.filter { !negotiations.contains($0.negotiationId) }
        return returns
    }
    
    mutating func append(noDuplicate item: Element) {
        if !self.contains(where: { $0.negotiationId == item.negotiationId }) {
            self.append(item)
        } else {
            guard let index = self.firstIndex(where: { $0.negotiationId == item.negotiationId }) else { return }
            self[index] = item
        }
    }
    
    mutating func negotiation(negotiationId: String) -> Element {
        guard let negotiation = self.first(where: { $0.negotiationId == negotiationId }) else { return Negotiation() }
        return negotiation
    }
}

extension Array where Element == Deal {
    var success: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        return self.filter { $0.condition == .success && ($0.proposerUserId == myUserId || $0.clientUserId == myUserId) }
    }
   
    var proposing: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        return self.filter { $0.condition == .proposed && $0.proposerUserId == myUserId }
    }
    
    var proposed: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        return self.filter { $0.condition == .proposed && $0.clientUserId == myUserId }
    }
    
    var fulfilled: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        return self.filter { $0.condition == .fulfilled && ($0.proposerUserId == myUserId || $0.clientUserId == myUserId) }
    }
    
    var failure: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        return self.filter { $0.condition == .failure && ($0.proposerUserId == myUserId || $0.clientUserId == myUserId) }
    }
    
    mutating func append(noDuplicate item: Element) {
        if !self.contains(where: { $0.dealId == item.dealId }) {
            self.append(item)
        } else {
            guard let index = self.firstIndex(where: { $0.dealId == item.dealId }) else { return }
            self[index] = item
        }
    }
    mutating func append(ifNoOverlap item: Element) {
        if !self.contains(where: { $0.dealId == item.dealId }) {
            self.append(item)
        }
    }
    mutating func remove(deal: Element) {
        guard let index = self.firstIndex(where: { $0 == deal }) else { return }
        self.remove(at: index)
    }
}

extension Dictionary where Element == (key: UserDataStore.listenerType, value: ListenerRegistration) {
    mutating func remove(listenerType: UserDataStore.listenerType) {
        UserDataStore.shared.listeners[listenerType]?.remove()
        UserDataStore.shared.listeners.removeValue(forKey: listenerType)
    }
}
