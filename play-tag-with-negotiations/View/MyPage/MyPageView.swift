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
        }
        .background(Color(UIColor.systemGray6))
        .navigationTitle("マイページ")
        .onAppear() {
            Observe.observeUser()
        }
    }
}

#Preview {
    MyPageView(userDataStore: UserDataStore.shared)
}
