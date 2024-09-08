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
                Text(String(negotiation.consumption) + "pt")
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onTapGesture {
            Task {
                await Create.proposeDeal(negotiation: negotiation)
                isShowAlert = true
            }
        }
        .alert("取引を提案しました", isPresented: $isShowAlert, actions: {
            Button(action: {}, label: {
                Text("OK")
            })
        })
    }
}

//#Preview {
//    DealPanelViewNegotiationCell()
//}
