//
//  NegotiationTargetView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/25.
//

import SwiftUI

struct DealPanelView: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    
    enum status: String, CaseIterable, Identifiable {
        case success, negotiation, proposing, proposed, fulfilled, failure
        
        var displayName: String {
            switch self {
            case .success: return "履行中"
            case .negotiation: return "提案可能"
            case .proposing: return "提案中"
            case .proposed: return "保留中"
            case .fulfilled: return "履行済"
            case .failure: return "失敗"
            }
        }
        var id: Self {
            self
        }
    }
    
    @State var pickerStatus: DealPanelView.status = .success
    
    var body: some View {
        VStack {
            Picker("取引", selection: $pickerStatus) {
                ForEach(status.allCases) { status in
                    Text(status.displayName)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            switch pickerStatus {
            case .success:
                if !playerDataStore.dealArray.success.isEmpty {
                    List(playerDataStore.dealArray.success) { deal in
                        DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}), dealType: .success)
                    }
                } else {
                    Spacer()
                    Text("履行中の取引はありません")
                    Spacer()
                }
            case .negotiation:
                if playerDataStore.negotiationArray.canPropose.isEmpty {
                    List(playerDataStore.negotiationArray.canPropose) { negotiaion in
                        DealPanelViewNegotiationCell(negotiation: Binding(get: { negotiaion }, set: {_ in}))
                    }
                } else {
                    Spacer()
                    Text("可能な取引がありません")
                    Spacer()
                }
            case .proposing:
                if !playerDataStore.dealArray.proposing.isEmpty {
                    List(playerDataStore.dealArray.proposing) { deal in
                        DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}), dealType: .proposing)
                    }
                } else {
                    Spacer()
                    Text("提案中の取引はありません")
                    Spacer()
                }
            case .proposed:
                if !playerDataStore.dealArray.proposed.isEmpty {
                    List(playerDataStore.dealArray.proposed) { deal in
                        DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}), dealType: .proposed)
                    }
                } else {
                    Spacer()
                    Text("保留中の取引はありません")
                    Spacer()
                }
            case .fulfilled:
                if !playerDataStore.dealArray.fulfilled.isEmpty {
                    List(playerDataStore.dealArray.fulfilled) { deal in
                        DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}), dealType: .fulfilled)
                    }
                } else {
                    Spacer()
                    Text("履行済の取引はありません")
                    Spacer()
                }
            case .failure:
                if !playerDataStore.dealArray.failure.isEmpty {
                    List(playerDataStore.dealArray.failure) { deal in
                        DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}), dealType: .failure)
                    }
                } else {
                    Spacer()
                    Text("失敗した取引はありません")
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DealPanelView(playerDataStore: PlayerDataStore.shared)
}
