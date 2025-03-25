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
    @State private var isShowUpdateAlert: Bool = false
    
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
        .alert("最新版があります", isPresented: $isShowUpdateAlert, actions: {
            Button(action: {
                if let url = URL(string: "https://itunes.apple.com/app/apple-store/id6504573276") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }, label: {
                Text("App Storeへ")
            })
        }, message: {
            Text("App Storeからアプリを最新版に更新してください。")
        })
        .onAppear() {
            Task {
                await AuthRepository.isSignIn()
                isShowUpdateAlert = await AppVersionRepository.versionCheck()
            }
        }
    }
}

#Preview {
    ContentView()
}
