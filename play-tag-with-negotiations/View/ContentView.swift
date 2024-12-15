//
//  ContentView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct ContentView: View {
    @StateObject var userDataStore = UserDataStore.shared
    @StateObject var playerDataStore = PlayerDataStore.shared
    
    var body: some View {
        Group {
            if userDataStore.userResult == nil {
                let iconHeight = UIScreen.main.bounds.height / 4
                VStack {
                    Spacer()
                    Image("Icon")
                        .resizable()
                        .frame(width: iconHeight, height: iconHeight)
                        .clipShape(RoundedRectangle(cornerRadius: iconHeight * 0.1675))
                    Spacer()
                    Text("ログインデータを確認中...")
                    Spacer()
                }
            } else {
                if userDataStore.signInUser == nil {
                    SignInView()
                } else {
                    PublicRoomsView(userDataStore: userDataStore, playerDataStore: playerDataStore)
                }
            }
        }
        .onAppear() {
            Task { await CheckSignIn.isSignIn() }
        }
    }
}

#Preview {
    ContentView()
}
