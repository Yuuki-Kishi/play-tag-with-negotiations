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
    var negotiationId: String
    var negotiationName: NegotiationName
    var displayName: String
    var target: Target
    var iconName: String
    var version: Double
    
    enum Target: String {
        case chaser, fugitive, both, unknown
    }
    
    enum NegotiationName: String {
        case missOnce, freezeOnce, changePosition, unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case negotiationId, negotiationName, displayName, target, iconName, version
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.negotiationId = try container.decode(String.self, forKey: .negotiationId)
        let negotiationName = try container.decode(String.self, forKey: .negotiationName)
        self.negotiationName = NegotiationName(rawValue: negotiationName) ?? .unknown
        self.displayName = try container.decode(String.self, forKey: .displayName)
        let target = try container.decode(String.self, forKey: .target)
        self.target = Target(rawValue: target) ?? .unknown
        self.iconName = try container.decode(String.self, forKey: .iconName)
        self.version = try container.decode(Double.self, forKey: .version)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.negotiationId, forKey: .negotiationId)
        try container.encode(self.negotiationName.rawValue, forKey: .negotiationName)
        try container.encode(self.displayName, forKey: .displayName)
        try container.encode(self.target.rawValue, forKey: .target)
        try container.encode(self.iconName, forKey: .iconName)
        try container.encode(self.version, forKey: .version)
    }
    
    init(negotiationId: String, negotiationName: NegotiationName, displayName: String, target: Target, iconName: String, version: Double) {
        self.id = UUID()
        self.negotiationId = negotiationId
        self.negotiationName = negotiationName
        self.displayName = displayName
        self.target = target
        self.iconName = iconName
        self.version = version
    }
    
    init() {
        self.id = UUID()
        self.negotiationId = UUID().uuidString
        self.negotiationName = .unknown
        self.displayName = "unknown"
        self.target = .unknown
        self.iconName = "questionmark"
        self.version = 1.0
    }
}
