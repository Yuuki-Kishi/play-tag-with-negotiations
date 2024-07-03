//
//  WaitingRoomView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/15.
//

import SwiftUI

struct WaitingRoomView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    
    var body: some View {
        ZStack {
            List {
                Section(content: {
                    WaitingRoomCellView(userDataStore: userDataStore, user: $playerDataStore.hostUser)
                }, header: {
                    Text("ホスト")
                })
                Section(content: {
                    ForEach($playerDataStore.userArray, id: \.self) { user in
                        if user.wrappedValue != playerDataStore.hostUser {
                            WaitingRoomCellView(userDataStore: userDataStore, user: user)
                        }
                    }
                }, header: {
                    Text("ゲスト")
                })
            }
            Button(action: {
               
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 75, height: 75)
                    Image(systemName: "play.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.primary)
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.trailing, 35)
            .padding(.bottom, 35)
        }
        .navigationTitle("待合室")
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            Observe.observePlayer()
        }
    }
}

#Preview {
    WaitingRoomView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
