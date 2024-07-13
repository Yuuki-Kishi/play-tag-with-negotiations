//
//  NegotiationPanelViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/12.
//

import SwiftUI

struct NegotiationPanelViewCell: View {
    @Binding var user: User
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .font(.system(size: 50.0))
                .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
            VStack {
                Text(user.userName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25))
                Text(user.pronoun)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .font(.system(size: 15))
            }
        }
    }
}

//#Preview {
//    NegotiationPanelViewCell(user: User())
//}
