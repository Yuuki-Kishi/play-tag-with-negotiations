//
//  NegotiationTargetViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/25.
//

import SwiftUI

struct TargetPanelViewCell: View {
    @Binding var negotiation: Negotiation
    @State private var isShowDealedAlert = false
    
    var body: some View {
        HStack {
            Image(systemName: negotiation.imageName)
                .font(.system(size: 25))
                .frame(width: 50)
                .foregroundStyle(Color.accentColor)
            VStack {
                Text(negotiation.displayName)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(negotiation.consumption) + "pt")
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onTapGesture {
            Task {
                await Create.proposeDeal(negotiation: negotiation)
                isShowDealedAlert = true
            }
        }
        .alert("取引を提案しました", isPresented: $isShowDealedAlert, actions: {
            Button(action: {}, label: {
                Text("OK")
            })
        })
    }
}

//#Preview {
//    NegotiationTargetViewCell()
//}
