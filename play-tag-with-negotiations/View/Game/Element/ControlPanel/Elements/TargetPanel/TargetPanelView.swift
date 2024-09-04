//
//  NegotiationTargetView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/25.
//

import SwiftUI

struct TargetPanelView: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        List($playerDataStore.negotiationArray) { negotiation in
            TargetPanelViewCell(negotiation: negotiation)
        }
        .onAppear() {
            Task {
                await Get.getNegotiations()
            }
        }
    }
}

#Preview {
    TargetPanelView(playerDataStore: PlayerDataStore.shared)
}
