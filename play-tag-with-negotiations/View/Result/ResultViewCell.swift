//
//  ResultViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/10.
//

import SwiftUI

struct ResultViewCell: View {
    @ObservedObject var userDataStore: UserDataStore
    @State var rankText: String
    @State var rankTextColor: Color
    @State var user: User
    @Binding var player: Player
    
    var body: some View {
        HStack {
            Text(rankText)
                .font(.system(size: 30))
                .foregroundStyle(rankTextColor)
            Spacer()
            Text(user.userName)
                .frame(alignment: .leading)
                .font(.system(size: 25))
                .foregroundStyle(userNameColor())
            Spacer()
            Spacer()
            Text(String(player.point) + "pt")
                .font(.system(size: 30))
                .foregroundStyle(Color.primary)
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
//    ResultViewCell(userDataStore: UserDataStore.shared, rank: 1, user: User(), player: Player())
//}
