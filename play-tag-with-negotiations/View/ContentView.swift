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
                Text("読み込み中...")
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
