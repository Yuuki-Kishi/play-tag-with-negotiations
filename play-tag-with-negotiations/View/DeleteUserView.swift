//
//  DeleteUserView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/25.
//

import SwiftUI

struct DeleteUserView: View {
    @State private var isShowAlert = false
    
    var body: some View {
        Spacer(minLength: 50)
        Image("Icon")
            .resizable()
            .frame(width: UIScreen.main.bounds.height / 4, height: UIScreen.main.bounds.height / 4)
            .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.bounds.height / 4 * 0.1675))
        Spacer(minLength: UIScreen.main.bounds.height / 6)
        Text("アカウントを削除するとあなたに関わる全ての情報が削除されます。\n削除にあたって再度サインインを求められる場合があります。")
            .multilineTextAlignment(.center)
            .frame(width: UIScreen.main.bounds.width / 1.5)
        Spacer()
        Button(action: {
            isShowAlert = true
        }, label: {
            Text("アカウントを削除")
                .foregroundStyle(.red)
                .frame(width: UIScreen.main.bounds.width / 1.5, height: 40)
                .overlay (
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.red, lineWidth: 2)
                )
        })
        .navigationTitle("アカウント削除")
        .alert("本当に削除しますか？", isPresented: $isShowAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                AuthRepository.reauthenticateAndDeleteUser()
            }, label: {
                Text("削除")
            })
        }, message: {
            Text("この操作は取り消すことができません。")
        })
        Spacer()
    }
}

#Preview {
    DeleteUserView()
}
