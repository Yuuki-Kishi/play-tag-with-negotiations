//
//  WaitingRoomCellView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/17.
//

import SwiftUI

struct WaitingRoomCellView: View {
    @Binding var user: User
    
    var body: some View {
        Section {
            HStack {
                Image(systemName: "person")
                    .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                VStack {
                    Text(user.userName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 25))
                    Text(user.pronoun)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                }
            }
        }
    }
}

//#Preview {
//    WaitingRoomCellView(user: User())
//}
