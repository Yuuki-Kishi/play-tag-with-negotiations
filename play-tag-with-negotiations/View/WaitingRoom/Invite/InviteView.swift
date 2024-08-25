//
//  InviteView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/24.
//

import SwiftUI

struct InviteView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var friendsArray: [User] = []
    @State private var selectionValue: Set<User> = []
    
    var body: some View {
        List(selection: $selectionValue) {
            ForEach($friendsArray, id: \.self) { friend in
                InviteViewCell(friend: friend)
            }
        }
        .environment(\.editMode, .constant(.active))
        .navigationTitle("招待するフレンドを選択")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                HStack {
                    Button(action: {
                        if selectionValue.isEmpty {
                            selectionValue = Set(friendsArray)
                        } else {
                            selectionValue = []
                        }
                    }, label: {
                        if selectionValue.isEmpty {
                            Text("全選択")
                        } else {
                            Text("全解除")
                        }
                    })
                    Button(action: {
                        Task {
                            await CreateToFirestore.sendInviteNotice(users: selectionValue, roomId: playerDataStore.playingRoom.roomId.uuidString)
                            pathDataStore.navigatetionPath.removeLast()
                        }
                    }, label: {
                        Text("送信")
                    })
                }
            })
        }
        .onAppear() {
            Task {
                guard let friends = userDataStore.signInUser?.friendsId else { return }
                for friend in friends {
                    guard let user = await ReadToFirestore.getUserData(userId: friend) else { return }
                    friendsArray.append(ifNoOverlap: user)
                }
            }
        }
    }
}

#Preview {
    InviteView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, pathDataStore: PathDataStore.shared)
}
