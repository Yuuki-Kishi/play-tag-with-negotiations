//
//  NoticeViewCell.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/08/21.
//

import SwiftUI

struct NoticeViewCell: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @Binding var notice: Notice
    @State private var isShowAlert: Bool = false
    
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
                HStack {
                    Text(notice.sendUser.userName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 20))
                    Spacer()
                    Text(noticeType())
                        .foregroundStyle(noticeTypeColor())
                        .frame(alignment: .trailing)
                        .lineLimit(1)
                        .font(.system(size: 15))
                    Spacer()
                }
                HStack {
                    Text(dateToString())
                        .frame(alignment: .leading)
                        .lineLimit(1)
                        .font(.system(size: 15))
                    Spacer()
                }
            }
        }
        .onTapGesture {
            Task {
                switch notice.noticeType {
                case .friendShip:
                    pathDataStore.navigatetionPath.append(.friend)
                case .invite:
                    await joinRoom()
                case .unknown:
                    break
                }
                await NoticeRepository.deleteNotice(noticeId: notice.noticeId)
            }
        }
        .alert("部屋が存在しません", isPresented: $isShowAlert, actions: {
            Button(action: {}, label: {
                Text("OK")
            })
        }, message: {
            Text("通知から時間が経過している可能性があります。\n詳細は招待者にお尋ねください。")
        })
    }
    func noticeType() -> String {
        switch notice.noticeType {
        case .friendShip:
            return "フレンド申請"
        case .invite:
            return "ルームへの招待"
        case .unknown:
            return "不明"
        }
    }
    func noticeTypeColor() -> Color {
        switch notice.noticeType {
        case .friendShip:
            return Color.red
        case .invite:
            return Color.teal
        case .unknown:
            return Color.gray
        }
    }
    func getIconImage() -> UIImage? {
        if let iconData = notice.sendUser.iconData {
            return UIImage(data: iconData)
        } else {
            return nil
        }
    }
    func dateToString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateformatter.string(from: notice.sendDate)
    }
    func joinRoom() async {
        if await PlayTagRoomRepository.isExists(roomId: notice.roomId) {
            guard let playingRoom = await PlayTagRoomRepository.getRoomData(roomId: notice.roomId) else { return }
            DispatchQueue.main.async {
                playerDataStore.playingRoom = playingRoom
            }
            await PlayerRepository.enterRoom(roomId: notice.roomId, isHost: false)
            pathDataStore.navigatetionPath.append(.waitingRoom)
        } else {
            isShowAlert = true
        }
    }
}

//#Preview {
//    NoticeViewCell(userDataStore: UserDataStore.shared)
//}
