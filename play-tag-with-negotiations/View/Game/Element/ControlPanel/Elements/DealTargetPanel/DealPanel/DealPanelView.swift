//
//  NegotiationTargetView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/25.
//

import SwiftUI

struct DealPanelView: View {
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        if negotiationIsEmpty() && playerDataStore.dealArray.isEmpty {
            Text("可能な取引がありません")
                .frame(alignment: .center)
        } else {
            List {
                if !playerDataStore.dealArray.proposed.isEmpty {
                    Section(content: {
                        ForEach(playerDataStore.dealArray.proposed, id: \.self) { deal in
                            DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}), dealType: .proposed)
                        }
                    }, header: {
                        Text("提案された取引")
                    })
                }
                if !playerDataStore.dealArray.success.isEmpty {
                    Section(content: {
                        ForEach(playerDataStore.dealArray.success, id: \.self) { deal in
                            DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}), dealType: .success)
                        }
                    }, header: {
                        Text("履行中の取引")
                    })
                }
                if playerDataStore.playerArray.me.isChaser {
                    if !playerDataStore.negotiationArray.filter({ $0.target == .chaser }).canPropose.isEmpty {
                        Section(content: {
                            ForEach(playerDataStore.negotiationArray.filter({ $0.target == .chaser }).canPropose, id: \.self) { negotiation in
                                DealPanelViewNegotiationCell(negotiation: Binding(get: { negotiation }, set: {_ in}))
                            }
                        }, header: {
                            Text("提案できる取引")
                        })
                    }
                } else {
                    if !playerDataStore.negotiationArray.filter({ $0.target == .fugitive }).canPropose.isEmpty {
                        Section(content: {
                            ForEach(playerDataStore.negotiationArray.filter({ $0.target == .fugitive }).canPropose, id: \.self) { negotiation in
                                DealPanelViewNegotiationCell(negotiation: Binding(get: { negotiation }, set: {_ in}))
                            }
                        }, header: {
                            Text("提案できる取引")
                        })
                    }
                }
                if !playerDataStore.dealArray.proposing.isEmpty {
                    Section(content: {
                        ForEach(playerDataStore.dealArray.proposing, id: \.self) { deal in
                            DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}), dealType: .proposing)
                        }
                    }, header: {
                        Text("提案中の取引")
                    })
                }
                if !playerDataStore.dealArray.fulfilled.isEmpty {
                    Section(content: {
                        ForEach(playerDataStore.dealArray.fulfilled, id: \.self) { deal in
                            DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}), dealType: .fulfilled)
                        }
                    }, header: {
                        Text("履行した取引")
                    })
                }
                if !playerDataStore.dealArray.failured.isEmpty {
                    Section(content: {
                        ForEach(playerDataStore.dealArray.failured, id: \.self) { deal in
                            DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}), dealType: .failure)
                        }
                    }, header: {
                        Text("失敗した取引")
                    })
                }
            }
        }
    }
    func negotiationIsEmpty() -> Bool {
        if playerDataStore.playerArray.me.isChaser {
            return playerDataStore.negotiationArray.filter { $0.target == .chaser }.isEmpty
        } else {
            return playerDataStore.negotiationArray.filter { $0.target == .fugitive }.isEmpty
        }
    }
}

#Preview {
    DealPanelView(playerDataStore: PlayerDataStore.shared)
}
