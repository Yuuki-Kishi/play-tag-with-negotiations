//
//  Negotiation.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/08.
//

import SwiftUI

struct DealPanelViewNegotiationCell: View {
    @Binding var negotiation: Negotiation
    @State private var point: String = ""
    @State private var isShowAlert = false
    
    var body: some View {
        HStack {
            Image(systemName: negotiation.iconName)
                .font(.system(size: 25))
                .frame(width: 50)
                .foregroundStyle(Color.accentColor)
            VStack {
                Text(negotiation.displayName)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onTapGesture {
            isShowAlert = true
        }
        .alert("支払うポイント数を入力", isPresented: $isShowAlert, actions: {
            TextField("支払うポイント数", text: $point)
            Button(role: .cancel, action: {
                point = ""
            }, label: {
                Text("キャンセル")
            })
            Button(action: {
                let targetUserId = PlayerDataStore.shared.selectedPlayer.playerUserId
                Task {
                    await DealRepository.proposeDeal(targetUserId: targetUserId, negotiation: negotiation, point: point)
                    point = ""
                }
            }, label: {
                Text("提案")
            })
        }, message: {
            Text("0以上、保有ポイント数以下の整数以外を入力するとキャンセルされます。")
        })
    }
}

//#Preview {
//    DealPanelViewNegotiationCell()
//}
