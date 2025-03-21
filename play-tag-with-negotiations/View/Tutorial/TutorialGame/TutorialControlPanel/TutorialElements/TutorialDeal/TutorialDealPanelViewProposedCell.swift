//
//  TutorialDealPanelViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialDealPanelViewProposedCell: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
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
                deal.condition = .success
            }, label: {
                Text("承諾")
            })
            Button(role: .destructive, action: { }, label: {
                Text("拒否")
            })
        }, message: {
            Text("承諾しなかった場合、取引は失敗となります。")
        })
    }
    func negotiation() -> Negotiation {
        guard let negotiation = tutorialDataStore.tutorialNegotiationArray.first(where: { $0.negotiationId == deal.negotiationId }) else { return Negotiation() }
        return negotiation
    }
}

//#Preview {
//    TutorialDealPanelViewProposedCell(tutorialDataStore: TutorialDataStore.shared, deal: Deal())
//}
