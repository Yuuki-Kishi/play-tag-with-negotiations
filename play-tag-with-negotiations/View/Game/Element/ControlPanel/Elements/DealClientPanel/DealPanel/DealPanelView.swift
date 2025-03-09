//
//  NegotiationTargetView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/25.
//

import SwiftUI

struct DealPanelView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
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
    
    @State var pickerStatus: DealPanelView.status = .success
    
    var body: some View {
        if playerDataStore.selectedPlayer.isMe {
            VStack {
                userInfo()
                Spacer()
                Text("自分と取引することはできません。")
                Spacer()
            }
        } else {
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
                    if !playerDataStore.dealArray.success.isEmpty {
                        List(playerDataStore.dealArray.success) { deal in
                            DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}))
                        }
                        .padding(0)
                    } else {
                        Spacer()
                        Text("履行中の取引はありません")
                        Spacer()
                    }
                case .negotiation:
                    if !playerDataStore.negotiationArray.canPropose.isEmpty {
                        List(playerDataStore.negotiationArray.canPropose) { negotiaion in
                            DealPanelViewNegotiationCell(negotiation: Binding(get: { negotiaion }, set: {_ in}))
                        }
                        .padding(0)
                    } else {
                        Spacer()
                        Text("可能な取引がありません")
                        Spacer()
                    }
                case .proposing:
                    if !playerDataStore.dealArray.proposing.isEmpty {
                        List(playerDataStore.dealArray.proposing) { deal in
                            DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}))
                        }
                        .padding(0)
                    } else {
                        Spacer()
                        Text("提案中の取引はありません")
                        Spacer()
                    }
                case .proposed:
                    if !playerDataStore.dealArray.proposed.isEmpty {
                        List(playerDataStore.dealArray.proposed) { deal in
                            DealPanelViewProposedCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}))
                        }
                        .padding(0)
                    } else {
                        Spacer()
                        Text("保留中の取引はありません")
                        Spacer()
                    }
                case .fulfilled:
                    if !playerDataStore.dealArray.fulfilled.isEmpty {
                        List(playerDataStore.dealArray.fulfilled) { deal in
                            DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}))
                        }
                        .padding(0)
                    } else {
                        Spacer()
                        Text("履行済の取引はありません")
                        Spacer()
                    }
                case .failure:
                    if !playerDataStore.dealArray.failure.isEmpty {
                        List(playerDataStore.dealArray.failure) { deal in
                            DealPanelViewCell(playerDataStore: playerDataStore, deal: Binding(get: { deal }, set: {_ in}))
                        }
                        .padding(0)
                    } else {
                        Spacer()
                        Text("失敗した取引はありません")
                        Spacer()
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.25)
        }
    }
    func userInfo() -> some View {
        HStack {
            if let iconImage = getIconImage() {
                Image(uiImage: iconImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: UIScreen.main.bounds.width / 15, height: UIScreen.main.bounds.width / 15)
            } else {
                Image(systemName: "person.circle")
                    .foregroundStyle(Color.accentColor)
                    .font(.system(size: 20.0))
                    .frame(width: UIScreen.main.bounds.width / 15, height: UIScreen.main.bounds.width / 15)
            }
            Text(user().userName)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 20))
                .padding(.horizontal)
            Spacer()
            Button(action: {
                selectClear()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.gray)
            })
        }
        .padding(.horizontal)
    }
    func getIconImage() -> UIImage? {
        if let iconData = user().iconData {
            return UIImage(data: iconData)
        } else {
            return nil
        }
    }
    func user() -> User {
        guard let user = playerDataStore.userArray.first(where: { $0.userId == playerDataStore.selectedPlayer.playerUserId }) else { return User() }
        return user
    }
    func selectClear() {
        playerDataStore.selectedPlayers = playerDataStore.playerArray
        userDataStore.displayControlPanel = .deal(.client)
        playerDataStore.selectedPlayer = Player()
    }
}

#Preview {
    DealPanelView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
