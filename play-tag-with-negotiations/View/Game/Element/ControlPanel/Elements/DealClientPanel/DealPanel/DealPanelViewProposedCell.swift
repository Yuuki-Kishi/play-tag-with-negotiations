//
//  DealPanelViewProposedCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/10.
//

import SwiftUI

struct DealPanelViewProposedCell: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    @Binding var deal: Deal
    @State private var isShowAlert = false
    
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
            Text(String(deal.consideration) + "pt")
        }
        .onTapGesture {
            isShowAlert = true
        }
        .alert("取引を承諾しますか？", isPresented: $isShowAlert, actions: {
            Button(action: {
                Task { await DealSuccess.successDeal(deal: deal) }
            }, label: {
                Text("承諾")
            })
            Button(role: .destructive, action: {
                Task { await DealRepository.dealRefuse(deal: deal) }
            }, label: {
                Text("拒否")
            })
        }, message: {
            Text("承諾しなかった場合、取引は失敗となります。")
        })
    }
    func negotiation() -> Negotiation {
        guard let negotiation = playerDataStore.negotiationArray.first(where: { $0.negotiationId == deal.negotiationId }) else { return Negotiation() }
        return negotiation
    }
}

//#Preview {
//    DealPanelViewProposedCell(playerDataStore: PlayerDataStore.shared, deal: Deal())
//}
