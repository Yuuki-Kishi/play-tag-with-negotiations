//
//  PlayedRoomId.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/26.
//

import Foundation

struct PlayedRoomId: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: PlayedRoomId, rhs: PlayedRoomId) -> Bool {
        return lhs.roomId == rhs.roomId
    }
    
    var id = UUID()
    var roomId: String
    var playedDate: Date
    
    enum CodingKeys: CodingKey {
        case roomId, playedDate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.roomId = try container.decode(String.self, forKey: .roomId)
        let formatter = ISO8601DateFormatter()
        let dateString = try container.decode(String.self, forKey: .playedDate)
        if let date = formatter.date(from: dateString) {
            self.playedDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .playedDate, in: container, debugDescription: "Failed to decode creationDate.")
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.roomId, forKey: .roomId)
        let formattar = ISO8601DateFormatter()
        let dateString = formattar.string(from: playedDate)
        try container.encode(dateString, forKey: .playedDate)
    }
    
    init(roomId: String, playedDate: Date) {
        self.id = UUID()
        self.roomId = roomId
        self.playedDate = playedDate
    }
    
    init(roomId: String) {
        self.id = UUID()
        self.roomId = roomId
        self.playedDate = Date()
    }
    
    init() {
        self.id = UUID()
        self.roomId = "unknownRoomId"
        self.playedDate = Date()
    }
}
