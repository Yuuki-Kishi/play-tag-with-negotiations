//
//  MyPageView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/13.
//

import SwiftUI

struct MyPageView: View {
    @State private var icon: Image
    @State private var userName: String
    @State private var onePhrase: String
    
    init(icon: Image, userName: String, onePhrase: String) {
        self.icon = icon
        self.userName = userName
        self.onePhrase = onePhrase
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 50)
            icon
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.height / 4, height: UIScreen.main.bounds.height / 4)
                .border(Color.black)
            Spacer()
            List {
                HStack {
                    Text("ユーザーネーム")
                        .frame(alignment: .leading)
                    Spacer()
                    Text(userName)
                        .lineLimit(1)
                        .frame(width: .infinity, alignment: .trailing)
                        .foregroundStyle(Color.gray)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    
                }
                VStack {
                    Text("ひとこと")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    ScrollView {
                        Text(onePhrase)
                            .foregroundStyle(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .contentShape(Rectangle())
                .frame(maxHeight: UIScreen.main.bounds.height / 3)
                .onTapGesture {
                    
                }
            }
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
    MyPageView(icon: Image(systemName: "person"), userName: "わて", onePhrase: "しかのこのこのここしたんたん")
}
