//
//  WaitingRoomCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/17.
//

import SwiftUI

struct WaitingRoomViewCell: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @State var user: User
    @State private var isShowAlert = false
    
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
                    .font(.system(size: 15))
            }
            if user.userId != userDataStore.signInUser?.userId {
                Button(action: {
                    Task {
                        await CreateToFirestore.sendRequestOfFriend(to: user.userId)
                        isShowAlert = true
                    }
                }, label: {
                    Image(systemName: "paperplane.fill")
                })
                .buttonStyle(.plain)
                .frame(width: 30, height: 40)
                .foregroundStyle(Color.accentColor)
                .alert("フレンド申請を送信しました", isPresented: $isShowAlert, actions: {
                    Button(action: {}, label: {
                        Text("OK")
                    })
                })
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
//    WaitingRoomViewCell(user: User())
//}
