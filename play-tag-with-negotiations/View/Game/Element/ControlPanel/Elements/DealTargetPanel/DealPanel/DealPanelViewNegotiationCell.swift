//
//  Negotiation.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/08.
//

import SwiftUI

struct DealPanelViewNegotiationCell: View {
    @Binding var negotiation: Negotiation
    @State private var isShowAlert = false
    
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
                Text("消費" + String(negotiation.consumption) + "pt")
                    .font(.system(size: 15))
                    .foregroundStyle(pointColor())
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onTapGesture {
            let point = PlayerDataStore.shared.playerArray.me.point
            if point < negotiation.consumption {
                isShowAlert = true
            } else {
                Task {
                    await Propose.proposeDeal(negotiation: negotiation)
                }
            }
        }
        .alert("ポイントが不足しています", isPresented: $isShowAlert, actions: {
            Button(action: {}, label: {
                Text("OK")
            })
        })
    }
    func pointColor() -> Color {
        let point = PlayerDataStore.shared.playerArray.me.point
        if point < negotiation.consumption {
            return .red
        }
        return .primary
    }
}

//#Preview {
//    DealPanelViewNegotiationCell()
//}
