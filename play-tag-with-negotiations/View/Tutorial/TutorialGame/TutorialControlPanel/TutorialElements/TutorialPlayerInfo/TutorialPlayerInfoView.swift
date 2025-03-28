//
//  TutorialPlayerInfoView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialPlayerInfoView: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle")
                    .foregroundStyle(Color.accentColor)
                    .font(.system(size: 60.0))
                    .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                    .padding(.horizontal, 20)
                VStack {
                    Text(user().userName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 30))
                    Text(user().profile)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .font(.system(size: 15))
                }
            }
            HStack {
                Text("1st")
                    .foregroundStyle(Color.pink)
                    .font(.system(size: 59).bold())
                    .padding(.horizontal)
                Text(String(tutorialDataStore.tutorialSelectetPlayer.point) + "pt")
                    .font(.system(size: 50))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal)
    }
    func user() -> User {
        guard let user = tutorialDataStore.tutorialUserArray.first(where: { $0.userId == tutorialDataStore.tutorialSelectetPlayer.playerUserId }) else { return User() }
        return user
    }
}

#Preview {
    TutorialPlayerInfoView(tutorialDataStore: TutorialDataStore.shared)
}
