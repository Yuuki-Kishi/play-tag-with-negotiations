//
//  MyPageView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/13.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var userDataStore: UserDataStore
    
    var body: some View {
        VStack {
            Spacer(minLength: 50)
            Image(systemName: "person")
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.height / 4, height: UIScreen.main.bounds.height / 4)
            Spacer()
            MyPageListView(userDataStore: userDataStore)
            Spacer()
            Button(action: {
                
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                    Text("保存")
                        .foregroundStyle(Color.primary)
                }
            })
            .frame(width: UIScreen.main.bounds.width / 2, height: 30)
            .padding(.vertical, 30)
        }
        .background(Color(UIColor.systemGray6))
        .navigationTitle("マイページ")
    }
}

#Preview {
    MyPageView(userDataStore: UserDataStore.shared)
}
