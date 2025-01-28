//
//  FriendView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import SwiftUI

struct FriendShipView: View {
    @ObservedObject var userDataStore: UserDataStore
    @StateObject var friendDataStore =  FriendDataStore.shared
    
    enum status: String, CaseIterable, Identifiable {
        case friend
        case pending
        case applying
        
        var displayName: String {
            switch self {
            case .friend: return "フレンド"
            case .pending: return "保留中"
            case .applying: return "申請中"
            }
        }
        var id: Self {
            self
        }
    }
    
    @State var pickerStatus: FriendShipView.status = .friend
    
    var body: some View {
        VStack {
            Picker("フレンド", selection: $pickerStatus) {
                ForEach(status.allCases) { status in
                    Text(status.displayName)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            switch pickerStatus {
            case .friend:
                if !friendDataStore.friendShips.friends.isEmpty {
                    List(friendDataStore.friendShips.friends) { friendShip in
                        FriendViewCell(friendShip: Binding(get: { friendShip }, set: {_ in}), friend: friendShipToFriendUser(friendShip: friendShip))
                    }
                } else {
                    Spacer()
                    Text("フレンドがいません")
                    Spacer()
                }
            case .pending:
                if !friendDataStore.friendShips.pendings.isEmpty {
                    List(friendDataStore.friendShips.pendings) { friendShip in
                        PendingViewCell(friendShip: Binding(get: { friendShip }, set: {_ in}), friend: friendShipToFriendUser(friendShip: friendShip))
                    }
                } else {
                    Spacer()
                    Text("保留中のフレンド申請はありません")
                    Spacer()
                }
            case .applying:
                if !friendDataStore.friendShips.applyings.isEmpty {
                    List(friendDataStore.friendShips.applyings) { friendShip in
                        ApplyingViewCell(friendShip: Binding(get: { friendShip }, set: {_ in}), friend: friendShipToFriendUser(friendShip: friendShip))
                    }
                } else {
                    Spacer()
                    Text("フレンド申請中のプレイヤーはいません")
                    Spacer()
                }
            }
        }
        .navigationTitle("フレンド")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            FriendShipRepository.observeFriend()
        }
        .onDisappear() {
            userDataStore.listeners.remove(listenerType: .friend)
        }
        .background(Color(UIColor.systemGray6))
    }
    func friendShipToFriendUser(friendShip: FriendShip) -> User {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return User() }
        if friendShip.proposerUserId == myUserId {
            Task {
                guard let consenter = await UserRepository.getUserData(userId: friendShip.consenterUserId) else { return User() }
                return consenter
            }
        } else if friendShip.consenterUserId == myUserId {
            Task {
                guard let proposer = await UserRepository.getUserData(userId: friendShip.proposerUserId) else { return User() }
                return proposer
            }
        }
        return User()
    }
}

#Preview {
    FriendShipView(userDataStore: UserDataStore.shared, friendDataStore: FriendDataStore.shared)
}
