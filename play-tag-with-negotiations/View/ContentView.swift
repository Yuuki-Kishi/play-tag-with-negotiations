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
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @StateObject var roomDataStore = RoomDataStore.shared
    @State private var isShowModal = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 50)
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(Color.accentColor)
                    .frame(width: UIScreen.main.bounds.height / 4, height: UIScreen.main.bounds.height / 4)
                Spacer(minLength: UIScreen.main.bounds.height / 4)
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal), action: Google.handleSignInButton)
                    .frame(width: UIScreen.main.bounds.width / 1.5)
                    .padding(.bottom, 30)
                SignInWithAppleButton(.signIn) { request in
                    Apple.shared.signInWithApple(request: request)
                } onCompletion: { authResults in
                    Apple.shared.login(authRequest: authResults)
                }
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(width: UIScreen.main.bounds.width / 1.5, height: 40)
                Spacer()
            }
            .onChange(of: UserDataStore.shared.signInUser) {
                if UserDataStore.shared.signInUser != nil {
                    isShowModal = true
                }
            }
            .fullScreenCover(isPresented: $isShowModal, content: {
                PublicRoomsView(userDataStore: userDataStore, playerDataStore: playerDataStore, roomDataStore: roomDataStore).environmentObject(EnvironmentData())
            })
            .padding()
        }
        .onAppear() {
            Task { await CheckSignIn.isSignIn() }
        }
    }
}

#Preview {
    ContentView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, roomDataStore: RoomDataStore.shared)
}
