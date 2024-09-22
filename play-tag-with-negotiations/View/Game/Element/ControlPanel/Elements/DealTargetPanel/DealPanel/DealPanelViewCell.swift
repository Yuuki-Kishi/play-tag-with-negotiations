//
//  NegotiationTargetViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/25.
//

import SwiftUI

struct DealPanelViewCell: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    @Binding var deal: Deal
    @State var dealType: Deal.dealCondition
    @State private var isShowAlert = false
    
    var body: some View {
        HStack {
            Image(systemName: negotiation().imageName)
                .font(.system(size: 25))
                .frame(width: 50)
                .foregroundStyle(Color.accentColor)
            VStack {
                Text(negotiation().displayName)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("消費" + String(negotiation().consumption) + "pt")
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onTapGesture {
            switch dealType {
            case .proposed:
                isShowAlert = true
            default:
                break
            }
        }
        .alert("取引を承諾しますか？", isPresented: $isShowAlert, actions: {
            Button(role: .destructive, action: {
                Task { await DealUpdate.refuseDeal(deal: deal) }
            }, label: {
                Text("拒否")
            })
            Button(action: {
                Task { await Success.successDeal(deal: deal) }
            }, label: {
                Text("承諾")
            })
        }, message: {
            Text("承諾しなかった場合、取引は失敗となります。")
        })
    }
    func negotiation() -> Negotiation {
        guard let negotiation = playerDataStore.negotiationArray.first(where: { $0.negotiationId.uuidString == deal.negotiationId }) else { return Negotiation() }
        return negotiation
    }
}

//#Preview {
//    NegotiationTargetViewCell()
//}
