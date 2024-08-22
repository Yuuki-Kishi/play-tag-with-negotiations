//
//  NoticeViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/21.
//

import SwiftUI

struct NoticeViewCell: View {
    @ObservedObject var userDataStore: UserDataStore
    @Binding var notice: Notice
    
    var body: some View {
        HStack {
            if let iconImage = getIconImage() {
                Image(uiImage: iconImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
            } else {
                Image(systemName: "person.circle")
                    .foregroundStyle(Color.accentColor)
                    .font(.system(size: 40.0))
                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
            }
            VStack {
                Text(notice.sendUser.userName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25))
                HStack {
                    Text(dateToString())
                        .frame(width: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .font(.system(size: 15))
                    Spacer()
                    Text(noticeType())
                        .foregroundStyle(noticeTypeColor())
                        .frame(alignment: .trailing)
                        .lineLimit(1)
                        .font(.system(size: 15))
                    Spacer()
                }
            }
        }
    }
    func noticeType() -> String {
        switch notice.noticeType {
        case .friend:
            return "フレンド申請"
        case .invite:
            return "ルームへの招待"
        case .unknown:
            return "不明"
        }
    }
    func noticeTypeColor() -> Color {
        switch notice.noticeType {
        case .friend:
            return Color.red
        case .invite:
            return Color.teal
        case .unknown:
            return Color.gray
        }
    }
    func getIconImage() -> UIImage? {
        guard let user = userDataStore.signInUser else { return nil }
        if let iconData = user.iconData {
            return UIImage(data: iconData)
        } else {
            return nil
        }
    }
    func dateToString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateformatter.string(from: notice.sendTime)
    }
}

//#Preview {
//    NoticeViewCell(userDataStore: UserDataStore.shared)
//}
