//
//  WaitingRoomView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/15.
//

import SwiftUI

struct WaitingRoomView: View {
    @ObservedObject var userDataStore: UserDataStore
    @State private var userArray: [User] = [User()]
    
    var body: some View {
        ZStack {
            List($userArray) { user in
                WaitingRoomCellView(user: user)
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
    }
}

#Preview {
    WaitingRoomView(userDataStore: UserDataStore.shared)
}
