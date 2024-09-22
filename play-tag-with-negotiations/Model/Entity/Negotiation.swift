//
//  Negotiation.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/25.
//

import Foundation

struct Negotiation: Codable, Hashable, Identifiable, Equatable {
    static func == (lhs: Negotiation, rhs: Negotiation) -> Bool {
        return lhs.negotiationId == rhs.negotiationId
    }
    
    var id = UUID()
    var negotiationId: UUID
    var negotiationName: Name
    var displayName: String
    var consumption: Int
    var imageName: String
    var version: Double
    
    enum Name: String {
        case missOnce, unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case negotiationId, negotiationName, displayName, consumption, imageName, version
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.negotiationId = try container.decode(UUID.self, forKey: .negotiationId)
        let name = try container.decode(String.self, forKey: .negotiationName)
        self.negotiationName = Name(rawValue: name) ?? .unknown
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.consumption = try container.decode(Int.self, forKey: .consumption)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.version = try container.decode(Double.self, forKey: .version)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.negotiationId, forKey: .negotiationId)
        try container.encode(self.negotiationName.rawValue, forKey: .negotiationName)
        try container.encode(self.displayName, forKey: .displayName)
        try container.encode(self.consumption, forKey: .consumption)
        try container.encode(self.imageName, forKey: .imageName)
        try container.encode(self.version, forKey: .version)
    }
    
    init(negotiationId: UUID, negotiationName: Name, displayName: String, consumption: Int, imageName: String, version: Double) {
        self.id = UUID()
        self.negotiationId = negotiationId
        self.negotiationName = negotiationName
        self.displayName = displayName
        self.consumption = consumption
        self.imageName = imageName
        self.version = version
    }
    
    init() {
        self.id = UUID()
        self.negotiationId = UUID()
        self.negotiationName = .unknown
        self.displayName = "unknown"
        self.consumption = 666
        self.imageName = "questionmark"
        self.version = 1.0
    }
}
