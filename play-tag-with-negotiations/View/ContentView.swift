//
//  ContentView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import SwiftUI
import GoogleSignInSwift

struct ContentView: View {
    @State private var isShowModal = false
    @ObservedObject var userDataStore: UserDataStore
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 50)
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(Color.accentColor)
                    .frame(width: UIScreen.main.bounds.height / 4, height: UIScreen.main.bounds.height / 4)
                Spacer()
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel, action: GoogleAuth.handleSignInButton)
                    .frame(width: UIScreen.main.bounds.width / 1.5)
                Spacer()
            }
            .onChange(of: UserDataStore.shared.signInUser) {
                isShowModal = true
            }
            .fullScreenCover(isPresented: $isShowModal, content: {
                PublicRoomsView(userDataStore: userDataStore)
            })
            .padding()
        }
    }
}

#Preview {
    ContentView(userDataStore: UserDataStore.shared)
}
