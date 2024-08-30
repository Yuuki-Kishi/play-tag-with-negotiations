//
//  Array.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/14.
//

import Foundation

extension Array where Element == User {
    mutating func append(ifNoOverlap item: Element) {
        if !self.contains(where: { $0.userId == item.userId }) {
            self.append(item)
        } else {
            guard let index = self.firstIndex(where: { $0.userId == item.userId }) else { return }
            self[index] = item
        }
    }
}

extension Array where Element == Player {
    mutating func append(ifNoOverlap item: Element) {
        if !self.contains(where: { $0.userId == item.userId }) {
            self.append(item)
        } else {
            guard let index = self.firstIndex(where: { $0.userId == item.userId }) else { return }
            self[index] = item
        }
    }
}

extension Array where Element == Notice {
    mutating func append(ifNoOverlap item: Element) {
        if !self.contains(where: { $0.noticeId == item.noticeId }) {
            self.append(item)
        } else {
            guard let index = self.firstIndex(where: { $0.noticeId == item.noticeId }) else { return }
            self[index] = item
        }
    }
}

extension Array where Element == Negotiation {
    mutating func append(ifNoOverlap item: Element) {
        if !self.contains(where: { $0.negotiationId == item.negotiationId }) {
            self.append(item)
        } else {
            guard let index = self.firstIndex(where: { $0.negotiationId == item.negotiationId }) else { return }
            self[index] = item
        }
    }
}

extension Array where Element == Deal {
    mutating func append(ifNoOverlap item: Element) {
        if !self.contains(where: { $0.dealId == item.dealId }) {
            self.append(item)
        } else {
            guard let index = self.firstIndex(where: { $0.dealId == item.dealId }) else { return }
            self[index] = item
        }
    }
}
