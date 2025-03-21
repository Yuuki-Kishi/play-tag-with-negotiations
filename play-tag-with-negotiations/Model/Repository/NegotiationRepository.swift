//
//  NegotiationRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/12/09.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NegotiationRepository {
//    create
    
//    check
    
//    get
    static func getNegotiation(negotiationId: String) async -> Negotiation? {
        do {
            let document = try await Firestore.firestore().collection("Negotiations").document(negotiationId).getDocument()
            let negotiation = try document.data(as: Negotiation.self)
            return negotiation
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getNegotiations() async {
        do {
            guard let version = Double(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String) else { return }
            let documents = try await Firestore.firestore().collection("Negotiations").whereField("version", isLessThanOrEqualTo: version).getDocuments().documents
            for document in documents {
                let negotiation = try document.data(as: Negotiation.self)
                DispatchQueue.main.async {
                    PlayerDataStore.shared.negotiationArray.append(noDuplicate: negotiation)
                }
            }
        } catch {
            print(error)
        }
    }
    
//    update
    
//    delete
    
//    observe
}
