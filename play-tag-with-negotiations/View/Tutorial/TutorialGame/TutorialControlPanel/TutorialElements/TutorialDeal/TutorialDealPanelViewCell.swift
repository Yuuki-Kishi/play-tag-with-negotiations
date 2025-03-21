//
//  TutorialDealPanelViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialDealPanelViewCell: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    @Binding var deal: Deal
    
    var body: some View {
        HStack {
            Image(systemName: negotiation().iconName)
                .font(.system(size: 25))
                .frame(width: 50)
                .foregroundStyle(Color.accentColor)
            VStack {
                Text(negotiation().displayName)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    func negotiation() -> Negotiation {
        guard let negotiation = tutorialDataStore.tutorialNegotiationArray.first(where: { $0.negotiationId == deal.negotiationId }) else { return Negotiation() }
        return negotiation
    }
}

//#Preview {
//    TutorialDealPanelViewCell(tutorialDataStore: TutorialDataStore.shared, Deal())
//}
