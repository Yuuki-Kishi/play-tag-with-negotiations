//
//  PublicRoomsView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import SwiftUI

struct PublicRoomsView: View {
    @ObservedObject var userDataStore: UserDataStore
    @ObservedObject var playerDataStore: PlayerDataStore
    @StateObject var roomDataStore = RoomDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State private var isShowEnterRoomAlert = false
    @State private var isShowNotThereRoomAlert = false
    @State private var isShowOverPlayerAlert = false
    @State private var roomId = ""
    
    var body: some View {
        NavigationStack(path: $pathDataStore.navigatetionPath) {
            ZStack {
                List(roomDataStore.publicRoomsArray) { playTagRoom in
                    PublicRoomsViewCell(playerDataStore: playerDataStore, pathDataStore: pathDataStore, playTagRoom: playTagRoom)
                }
                .navigationDestination(for: PathDataStore.path.self) { path in
                    switch path {
                    case .roomSetting:
                        RoomSettingView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
                    case .notice:
                        NoticeView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
                    case .myPage:
                        MyPageView(userDataStore: userDataStore, pathDataStore: pathDataStore)
                    case .friend:
                        if pathDataStore.navigatetionPath[pathDataStore.navigatetionPath.count - 2] == .notice {
                            FriendView(isFriend: .notFriend)
                        } else {
                            FriendView(isFriend: .friend)
                        }
                    case .waitingRoom:
                        WaitingRoomView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
                    case .roomInfo:
                        RoomInfomationView(playerDataStore: playerDataStore)
                    case .invite:
                        InviteView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
                    case .game:
                        GameView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
                    case .negotiation:
                        EmptyView()
                    case .result:
                        ResultView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
                    }
                }
                Menu {
                    Button(action: {
                        pathDataStore.navigatetionPath.append(.roomSetting)
                    }, label: {
                        Label("ルーム作成", systemImage: "plus")
                    })
                    Button(action: {
                        isShowEnterRoomAlert = true
                    }, label: {
                        Label("ルームに参加", systemImage: "arrow.right.to.line.compact")
                    })
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 75, height: 75)
                        Image(systemName: "figure.run")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.primary)
                    }
                }
                .menuOrder(.fixed)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 35)
                .padding(.bottom, 35)
            }
            .navigationTitle("公開中")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    HStack {
                        Button(action: {
                            pathDataStore.navigatetionPath.append(.notice)
                        }, label: {
                            Image(systemName: noticeButtonIcon())
                        })
                        toolBarMenu()
                    }
                })
            }
            .alert("参加するルームID", isPresented: $isShowEnterRoomAlert, actions: {
                TextField("ルームID", text: $roomId)
                Button("キャンセル", role: .cancel, action: {})
                Button("入室", action: {
                    enterRoom()
                })
            })
            .alert("該当ルームが存在しません", isPresented: $isShowNotThereRoomAlert, actions: {
                Button(action: {}) {
                    Text("OK")
                }
            })
            .alert("参加できる人数を超えています", isPresented: $isShowOverPlayerAlert, actions: {
                Button(action: {}) {
                    Text("OK")
                }
            })
            .onAppear() {
                onAppear()
            }
            .onDisappear() {
                onDisappear()
            }
        }
    }
    func enterRoom() {
        Task {
            let isThereRoom = await Check.checkIsThereRoom(roomId: roomId)
            let isNotOverPlayer = await Check.checkNotOverPlayerCount(roomId: roomId)
            if isThereRoom {
                if isNotOverPlayer {
                    guard let playingRoom = await Get.getRoomData(roomId: roomId) else { return }
                    DispatchQueue.main.async {
                        playerDataStore.playingRoom = playingRoom
                    }
                    await Create.enterRoom(roomId: roomId, isHost: false)
                    roomId = ""
                    pathDataStore.navigatetionPath.append(.waitingRoom)
                } else {
                    isShowOverPlayerAlert = true
                }
            } else {
                isShowNotThereRoomAlert = true
            }
        }
    }
    func noticeButtonIcon() -> String {
        let noticeCount = userDataStore.noticeArray.filter { !$0.isChecked }.count
        if noticeCount > 0 {
            return "envelope.fill"
        }
        return "envelope"
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                pathDataStore.navigatetionPath.append(.myPage)
            }, label: {
                Label("マイページ", systemImage: "person.circle")
            })
            Menu {
                Button(action: { roomDataStore.publicRoomsArray.sort {$0.playTagName < $1.playTagName}}, label: {
                    Text("名前昇順")
                })
                Button(action: { roomDataStore.publicRoomsArray.sort {$0.playTagName > $1.playTagName}}, label: {
                    Text("名前降順")
                })
                Button(action: { roomDataStore.publicRoomsArray.sort {$0.phaseNow < $1.phaseNow}}, label: {
                    Text("フェーズ昇順")
                })
                Button(action: { roomDataStore.publicRoomsArray.sort {$0.phaseNow > $1.phaseNow}}, label: {
                    Text("フェーズ降順")
                })
            } label: {
                Label("並び替え", systemImage: "arrow.up.arrow.down")
            }
            Divider()
            Button(role: .destructive, action: {
                SignOut.signOut()
            }, label: {
                Text("サインアウト")
            })
        } label: {
            Image(systemName: "ellipsis.circle")
        }
        
    }
    func onAppear() {
        Task {
            if let roomId = await Get.getBeingRoomId() {
                guard let playingRoom = await Get.getRoomData(roomId: roomId) else { return }
                playerDataStore.playingRoom = playingRoom
                if playingRoom.isPlaying {
                    if !playingRoom.isEnd {
                        pathDataStore.navigatetionPath.append(.game)
                    }
                } else {
                    pathDataStore.navigatetionPath.append(.waitingRoom)
                }
                if playingRoom.isEnd {
                    await Delete.endGame()
                }
            } else {
                Observe.observePublicRooms()
                Observe.observeNotice()
            }
        }
    }
    func onDisappear() {
        userDataStore.listeners[.publicRooms]?.remove()
        userDataStore.listeners.removeValue(forKey: .publicRooms)
        userDataStore.listeners[.notice]?.remove()
        userDataStore.listeners.removeValue(forKey: .notice)
    }
}

#Preview {
    PublicRoomsView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, roomDataStore: RoomDataStore.shared)
}
