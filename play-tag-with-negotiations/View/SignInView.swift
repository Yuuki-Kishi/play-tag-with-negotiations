//
//  SignInView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/21.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct SignInView: View {
        
    var body: some View {
        VStack {
            Spacer(minLength: 50)
            Image("Icon")
                .resizable()
                .frame(width: UIScreen.main.bounds.height / 4, height: UIScreen.main.bounds.height / 4)
                .clipShape(RoundedRectangle(cornerRadius: 50))
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
        .padding()
    }
}

#Preview {
    SignInView()
}
