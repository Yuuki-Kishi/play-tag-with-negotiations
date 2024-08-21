//
//  NoticeViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/21.
//

import SwiftUI

struct NoticeViewCell: View {
    @ObservedObject var userDataStore: UserDataStore
    @State var notice: Notice = Notice()
    
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
                    .foregroundStyle(userNameColor())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25))
                Text(dateToString(date: notice.sendTime))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .font(.system(size: 15))
            }
        }
    }
    func userNameColor() -> Color {
        var color = Color.green
        if notice.noticeType == .friend {
            color = Color.orange
        }
        return color
    }
    func getIconImage() -> UIImage? {
        guard let user = userDataStore.signInUser else { return nil }
        if let iconData = user.iconData {
            return UIImage(data: iconData)
        } else {
            return nil
        }
    }
    func dateToString(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateformatter.string(from: date)
    }
}

#Preview {
    NoticeViewCell(userDataStore: UserDataStore.shared)
}
