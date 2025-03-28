//
//  TutorialDealPanel.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialDealPanelView: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    
    enum status: String, CaseIterable, Identifiable {
        case success, negotiation, proposing, proposed, fulfilled, failure
        
        var displayName: String {
            switch self {
            case .success: return "履行中"
            case .negotiation: return "提案可"
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
    
    @State var pickerStatus: TutorialDealPanelView.status = .success
    
    var body: some View {
        VStack {
            userInfo()
            Picker("取引", selection: $pickerStatus) {
                ForEach(status.allCases) { status in
                    Text(status.displayName)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            switch pickerStatus {
            case .success:
                if !tutorialDataStore.tutorialDealArray.success.isEmpty {
                    List(tutorialDataStore.tutorialDealArray.success) { deal in
                        TutorialDealPanelViewCell(tutorialDataStore: tutorialDataStore, deal: Binding(get: { deal }, set: {_ in}))
                    }
                    .padding(0)
                } else {
                    Spacer()
                    Text("履行中の取引はありません")
                    Spacer()
                }
            case .negotiation:
                if !tutorialDataStore.tutorialNegotiationArray.canPropose.isEmpty {
                    List(tutorialDataStore.tutorialNegotiationArray.canPropose) { negotiaion in
                        TutorialDealPanelViewNegotiationCell(negotiation: Binding(get: { negotiaion }, set: {_ in}))
                    }
                    .padding(0)
                } else {
                    Spacer()
                    Text("可能な取引がありません")
                    Spacer()
                }
            case .proposing:
                Spacer()
                Text("提案中の取引はありません")
                Spacer()
            case .proposed:
                if !tutorialDataStore.tutorialDealArray.proposed.isEmpty {
                    List(tutorialDataStore.tutorialDealArray.proposed) { deal in
                        TutorialDealPanelViewProposedCell(tutorialDataStore: tutorialDataStore, deal: Binding(get: { deal }, set: {_ in}))
                    }
                    .padding(0)
                } else {
                    Spacer()
                    Text("保留中の取引はありません")
                    Spacer()
                }
            case .fulfilled:
                Spacer()
                Text("履行済の取引はありません")
                Spacer()
            case .failure:
                Spacer()
                Text("失敗した取引はありません")
                Spacer()
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.25)
    }
    func userInfo() -> some View {
        HStack {
            Image(systemName: "person.circle")
                .foregroundStyle(Color.accentColor)
                .font(.system(size: 20.0))
                .frame(width: UIScreen.main.bounds.width / 15, height: UIScreen.main.bounds.width / 15)
            Text(user().userName)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 20))
                .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    func user() -> User {
        guard let user = tutorialDataStore.tutorialUserArray.first(where: { $0.userId == tutorialDataStore.tutorialSelectetPlayer.playerUserId }) else { return User() }
        return user
    }
}

#Preview {
    TutorialDealPanelView(tutorialDataStore: TutorialDataStore.shared)
}
