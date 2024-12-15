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
    
    mutating func delete(userId: String) {
        guard let index = self.firstIndex(where: { $0.userId == userId }) else { return }
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
    
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(where: { $0.playerUserId == item.playerUserId }) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    
    mutating func delete(userId: String) {
        guard let index = firstIndex(where: { $0.playerUserId == userId }) else { return }
        self.remove(at: index)
    }
}

extension Array where Element == Notice {
    mutating func append(noDuplicate item: Element) {
        if !self.contains(where: { $0.noticeId == item.noticeId }) {
            self.append(item)
        } else {
            guard let index = self.firstIndex(where: { $0.noticeId == item.noticeId }) else { return }
            self[index] = item
        }
    }
}

extension Array where Element == Negotiation {
    var canPropose: [Element] {
        let proposingDeals = PlayerDataStore.shared.dealArray.proposing + PlayerDataStore.shared.dealArray.proposed + PlayerDataStore.shared.dealArray.success
        let negotiations = proposingDeals.map { $0.negotiationId }
        return self.filter { !negotiations.contains($0.negotiationId.uuidString) }
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
        guard let negotiation = PlayerDataStore.shared.negotiationArray.first(where: { $0.negotiationId.uuidString == negotiationId }) else { return Negotiation() }
        return negotiation
    }
}

extension Array where Element == Deal {
    var success: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        let successDeals = self.filter { $0.condition == .success }
        return successDeals.filter { $0.proposerUserId == myUserId || $0.targetUserId == myUserId }
    }
    
    var proposing: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        let proposingDeals = self.filter { $0.condition == .proposing }
        return proposingDeals.filter { $0.proposerUserId == myUserId }
    }
    
    var proposed: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        let proposingDeals = self.filter { $0.condition == .proposing }
        return proposingDeals.filter { $0.targetUserId == myUserId }
    }
    
    var fulfilled: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        let fulfilledDeals = self.filter { $0.condition == .fulfilled }
        return fulfilledDeals.filter { $0.proposerUserId == myUserId || $0.targetUserId == myUserId }
    }
    
    var failured: [Element] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        let failuredDeals = self.filter { $0.condition == .failure }
        return failuredDeals.filter { $0.proposerUserId == myUserId || $0.targetUserId == myUserId }
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
    mutating func delete(deal: Element) {
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

extension Array where Element == Mission {
    var canExecute: [Element] {
        let executingQuest = PlayerDataStore.shared.questArray.filter { $0.condition == .executing }
        var canExcuteMission: [Mission] = []
        for mission in PlayerDataStore.shared.missionArray {
            let isContain = executingQuest.contains { $0.missionId == mission.missionId.uuidString }
            if !isContain { canExcuteMission.append(noDuplicate: mission) }
        }
        return canExcuteMission
    }
    
    mutating func append(noDuplicate item: Element) {
        if !self.contains(where: { $0.missionId == item.missionId }) {
            self.append(item)
        } else {
            guard let index = self.firstIndex(where: { $0.missionId == item.missionId }) else { return }
            self[index] = item
        }
    }
    mutating func mission(missionId: String) -> Mission {
        guard let mission = PlayerDataStore.shared.missionArray.first(where: { $0.missionId.uuidString == missionId }) else {
            return Mission() }
        return mission
    }
}

extension Array where Element == Quest {
    var completed: [Element] {
        return self.filter { $0.condition == .completed }
    }
    
    var executing: [Element] {
        return self.filter { $0.condition == .executing }
    }
    
    var failured: [Element] {
        return self.filter { $0.condition == .failured }
    }
}
