//
//  TutorialWaitingRoomViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI

struct TutorialWaitingRoomViewCell: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    @Binding var userId: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .foregroundStyle(Color.accentColor)
                .font(.system(size: 40.0))
                .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
            VStack {
                Text(user().userName)
                    .foregroundStyle(userNameColor())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25))
                Text(user().profile)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .font(.system(size: 15))
            }
        }
    }
    func userNameColor() -> Color {
        var color = Color.primary
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return color }
        if myUserId == userId {
            color = Color.green
        }
        return color
    }
    func user() -> User {
        guard let user = tutorialDataStore.tutorialUserArray.first(where: { $0.userId == userId }) else { return User() }
        return user
    }
}

//#Preview {
//    TutorialWaitingRoomViewCell(tutorialDataStore: TutorialDataStore.shared, userId: User())
//}
