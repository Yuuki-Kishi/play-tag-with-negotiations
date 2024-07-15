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
        }
    }
}
