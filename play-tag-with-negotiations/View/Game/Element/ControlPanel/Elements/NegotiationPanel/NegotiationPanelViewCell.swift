//
//  NegotiationPanelViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/12.
//

import SwiftUI

struct NegotiationPanelViewCell: View {
    @Binding var user: User
    @State private var icon: UIImage? = nil
    
    var body: some View {
        HStack {
            if let iconImage = icon {
                Image(uiImage: iconImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Image(systemName: "person")
                    .font(.system(size: 50.0))
                    .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
            }
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
        .onAppear() {
            getIcon(iconUrl: user.iconUrl)
        }
    }
    func getIcon(iconUrl: String) {
        if iconUrl != "default" {
            Task {
                guard let imageData = await ReadToStorage.getIconImage(iconUrl: iconUrl) else { return }
                icon = UIImage(data: imageData)
            }
        }
    }
}

//#Preview {
//    NegotiationPanelViewCell(user: User())
//}
