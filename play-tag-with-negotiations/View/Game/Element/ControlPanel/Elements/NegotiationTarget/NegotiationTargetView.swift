//
//  NegotiationTargetView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/25.
//

import SwiftUI

struct NegotiationTargetView: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        List($playerDataStore.negotiationArray) { negotiation in
            NegotiationTargetViewCell(negotiation: negotiation)
        }
        .onAppear() {
            Task {
                await Get.getNegotiations()
            }
        }
    }
}

#Preview {
    NegotiationTargetView(playerDataStore: PlayerDataStore.shared)
}
