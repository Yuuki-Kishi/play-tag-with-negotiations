//
//  NegotiationTargetViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/25.
//

import SwiftUI

struct DealPanelViewCell: View {
    @Binding var deal: Deal
    @State var dealType: dealCondition
    @State private var isShowAlert = false
    
    enum dealCondition: String {
        case success, failure, fulfilled, proposing, proposed, canPropose
    }
    
    var body: some View {
        HStack {
            Image(systemName: deal.negotiation.imageName)
                .font(.system(size: 25))
                .frame(width: 50)
                .foregroundStyle(Color.accentColor)
            VStack {
                Text(deal.negotiation.displayName)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(deal.negotiation.consumption) + "pt")
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
                Task { await Fulfill.fulfillDeal(deal: deal) }
            }, label: {
                Text("承諾")
            })
        }, message: {
            Text("承諾しなかった場合、取引は失敗となります。")
        })
    }
}

//#Preview {
//    NegotiationTargetViewCell()
//}
