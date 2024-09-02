//
//  Array.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/14.
//

import Foundation

extension Array where Element == User {
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(where: { $0.userId == item.userId }) {
            self[index] = item
        } else {
            self.append(item)
        }
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
        return self.map { $0.player }
    }
    
    var guests: [Element] {
        return self.filter { !$0.isHost }
    }
    
    var guestUsers: [User] {
        let guests = self.filter { !$0.isHost }
        return guests.map { $0.player }
    }
    
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(where: { $0.playerUserId == item.playerUserId }) {
            self[index] = item
        } else {
            self.append(item)
        }
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
    mutating func append(noDuplicate item: Element) {
        if !self.contains(where: { $0.negotiationId == item.negotiationId }) {
            self.append(item)
        } else {
            guard let index = self.firstIndex(where: { $0.negotiationId == item.negotiationId }) else { return }
            self[index] = item
        }
    }
}

extension Array where Element == Deal {
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
}
