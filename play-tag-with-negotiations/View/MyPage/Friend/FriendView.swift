//
//  FriendView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/13.
//

import SwiftUI

struct FriendView: View {
    @StateObject var friendDataStore =  FriendDataStore.shared
    
    enum picker: String, CaseIterable, Identifiable {
        case friend
        case notFriend
        
        var displayName: String {
            switch self {
            case .friend: return "フレンド"
            case .notFriend: return "リクエスト"
            }
        }
        var id: Self {
            self
        }
    }
    
    @State var isFriend: FriendView.picker
    
    var body: some View {
        VStack {
            Picker("フレンド", selection: $isFriend) {
                ForEach(picker.allCases) { friend in
                    Text(friend.displayName)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            switch isFriend {
            case .friend:
                List {
                    ForEach($friendDataStore.friendArray, id: \.userId) { friend in
                        FriendViewCell(friend: friend)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(UIColor.systemGray6))
            case .notFriend:
                List {
                    ForEach($friendDataStore.requestUserArray, id: \.userId) { requestUser in
                        NotFriendViewCell(friend: requestUser)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(UIColor.systemGray6))
            }
        }
        .navigationTitle("フレンド")
        .onAppear() {
            Observe.observeFriend()
        }
        .background(Color(UIColor.systemGray6))
    }
}

#Preview {
    FriendView(friendDataStore: FriendDataStore.shared, isFriend: .friend)
}
