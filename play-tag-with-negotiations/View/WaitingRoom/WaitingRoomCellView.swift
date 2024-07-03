//
//  WaitingRoomCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/17.
//

import SwiftUI

struct WaitingRoomCellView: View {
    @ObservedObject var userDataStore: UserDataStore
    @Binding var user: User
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .font(.system(size: 50.0))
                .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
            VStack {
                Text(user.userName)
                    .foregroundStyle(userNameColor())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25))
                Text(user.pronoun)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
        }
    }
    func userNameColor() -> Color {
        var color = Color.primary
        if user.userId == userDataStore.signInUser?.userId {
            color = Color.green
        }
        return color
    }
}

//#Preview {
//    WaitingRoomCellView(user: User())
//}
