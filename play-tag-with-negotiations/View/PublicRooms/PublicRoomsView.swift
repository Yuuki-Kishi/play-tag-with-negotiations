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
    @StateObject var tutorialDataStore =  TutorialDataStore.shared
    @State private var isShowEnterRoomAlert = false
    @State private var isShowNotThereRoomAlert = false
    @State private var isShowOverPlayerAlert = false
    @State private var isShowReplayAlert = false
    @State private var isShowUpdateAlert: Bool = false
    @State private var roomId = ""
    
    var body: some View {
        NavigationStack(path: $pathDataStore.navigatetionPath) {
            ZStack {
                VStack {
                    if !roomDataStore.publicRoomsArray.isEmpty {
                        List(roomDataStore.publicRoomsArray) { playTagRoom in
                            PublicRoomsViewCell(playerDataStore: playerDataStore, pathDataStore: pathDataStore, playTagRoom: playTagRoom)
                        }
                    } else {
                        Spacer()
                        Text("公開中のルームはありません")
                        Spacer()
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
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
                            Image(systemName: "figure.run")
                                .font(.system(size: 30))
                                .foregroundStyle(Color.primary)
                                .background(RoundedRectangle(cornerRadius: 25).frame(width: 75, height: 75))
                                .frame(width: 75, height: 75)
                        }
                        .menuOrder(.fixed)
                        .padding(.trailing, 40)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationDestination(for: PathDataStore.path.self) { path in
                destination(path: path)
            }
            .navigationTitle("ホーム")
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
//                ToolbarItem(placement: .topBarLeading, content: {
//                    Button(action: {
//                        pathDataStore.navigatetionPath.append(.tutorial)
//                    }, label: {
//                        Label("チュートリアル", systemImage: "questionmark.circle")
//                    })
//                })
            }
            .alert("参加先のルームID", isPresented: $isShowEnterRoomAlert, actions: {
                TextField("ルームID", text: $roomId)
                Button("キャンセル", role: .cancel, action: {
                    roomId = ""
                })
                Button("入室", action: {
                    if roomId != "" {
                        enterRoom()
                    }
                })
            })
            .alert("該当ルームが存在しません", isPresented: $isShowNotThereRoomAlert, actions: {
                Button(action: {
                    roomId = ""
                }) {
                    Text("OK")
                }
            })
            .alert("参加できる人数を超えています", isPresented: $isShowOverPlayerAlert, actions: {
                Button(action: {
                    roomId = ""
                }) {
                    Text("OK")
                }
            })
            .alert("参加中のルームがあります", isPresented: $isShowReplayAlert, actions: {
                Button(role: .destructive, action: {
                    cancelReplayGame()
                }, label: {
                    Text("やめる")
                })
                Button(role: .cancel, action: {
                    replayGame()
                }, label: {
                    Text("参加")
                })
            }, message: {
                Text("参加中のルームに戻りますか？参加をやめると再度参加にはルームIDが必要です。")
            })
            .alert("最新版があります", isPresented: $isShowUpdateAlert, actions: {
                Button(action: {
                    if let url = URL(string: "https://itunes.apple.com/app/apple-store/id6504573276") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }, label: {
                    Text("App Storeへ")
                })
            }, message: {
                Text("App Storeからアプリを最新版に更新してください。")
            })
            .onAppear() {
                onAppear()
            }
            .onDisappear() {
                onDisappear()
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.path) -> some View {
        switch path {
        case .tutorial:
            TutorialView(tutorialDataStore: tutorialDataStore, pathDataStore: pathDataStore)
        case .tutorialPublicRooms:
            TutorialPublicRoomsView(tutorailDataStore: tutorialDataStore, pathDataStore: pathDataStore)
        case .tutorialRoomSetting:
            TutorialRoomSettingView(tutorialDataStore: tutorialDataStore, pathDataStore: pathDataStore)
        case .tutorialWaitingRoom:
            TutorialWaitingRoomView(tutorialDataStore: tutorialDataStore, pathDataStore: pathDataStore)
        case .tutorialGame:
            TutorialGameVIew(tutorialDataStore: tutorialDataStore, pathDataStore: pathDataStore)
        case .TutorialResult:
            TutorialResultView(tutorialDataStore: tutorialDataStore, pathDataStore: pathDataStore)
        case .fightRecord:
            FightRecordView(userDataStore: userDataStore)
        case .roomSetting:
            RoomSettingView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
        case .notice:
            NoticeView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
        case .myPage:
            MyPageView(userDataStore: userDataStore, pathDataStore: pathDataStore)
        case .friend:
            FriendShipView(userDataStore: userDataStore, pickerStatus: .friend)
        case .waitingRoom:
            WaitingRoomView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
        case .roomInfo:
            RoomInfomationView(playerDataStore: playerDataStore)
        case .invite:
            InviteView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
        case .game:
            GameView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
        case .result:
            ResultView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
        case .deleteUser:
            DeleteUserView()
        }
    }
    func enterRoom() {
        Task {
            let isThereRoom = await PlayTagRoomRepository.isExists(roomId: roomId)
            let isOverPlayer = await PlayTagRoomRepository.isOverPlayerCount(roomId: roomId)
            if isThereRoom {
                if !isOverPlayer {
                    guard let myUserId = userDataStore.signInUser?.userId else { return }
                    guard let playingRoom = await PlayTagRoomRepository.getRoomData(roomId: roomId) else { return }
                    DispatchQueue.main.async {
                        playerDataStore.playingRoom = playingRoom
                    }
                    await PlayerRepository.enterRoom(roomId: roomId, isHost: false)
                    roomId = ""
                    if await PlayerRepository.isExsits(playerUserId: myUserId) {
                        pathDataStore.navigatetionPath.append(.waitingRoom)
                    }
                } else {
                    isShowOverPlayerAlert = true
                }
            } else {
                isShowNotThereRoomAlert = true
            }
        }
    }
    func replayGame() {
        Task {
            if await PlayTagRoomRepository.isExists(roomId: roomId) {
                if await !PlayTagRoomRepository.isOverPlayerCount(roomId: roomId) {
                    roomId = ""
                    if playerDataStore.playingRoom.isPlaying {
                        pathDataStore.navigatetionPath.append(.game)
                    } else {
                        pathDataStore.navigatetionPath.append(.waitingRoom)
                    }
                } else {
                    isShowOverPlayerAlert = true
                }
            } else {
                isShowNotThereRoomAlert = true
            }
        }
    }
    func cancelReplayGame() {
        Task {
            if await PlayTagRoomRepository.isExists(roomId: roomId) {
                guard let playingRoom = await PlayTagRoomRepository.getRoomData(roomId: roomId) else { return }
                roomId = ""
                await PlayerRepository.exitRoom(roomId: playingRoom.roomId)
            } else {
                await UserRepository.finishGame()
            }
        }
    }
    func noticeButtonIcon() -> String {
        let noticeCount = userDataStore.noticeArray.count
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
            Button(action: {
                pathDataStore.navigatetionPath.append(.fightRecord)
            }, label: {
                Label("戦績", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
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
                pathDataStore.navigatetionPath.append(.deleteUser)
            }, label: {
                Label("アカウント削除", systemImage: "trash.fill")
            })
            Button(role: .destructive, action: {
                AuthRepository.signOut()
            }, label: {
                Label("サインアウト", systemImage: "figure.walk.arrival")
            })
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func onAppear() {
        userDataStore.cleanUpListeners()
        playerDataStore.cleanUp()
        UserRepository.observeUserData()
        Task {
            if let roomId = await UserRepository.getCurrentRoomId() {
                guard let playingRoom = await PlayTagRoomRepository.getRoomData(roomId: roomId) else { return }
                playerDataStore.playingRoom = playingRoom
                if playingRoom.isFinished {
                    await UserRepository.finishGame()
                } else {
                    self.roomId = roomId
                    isShowReplayAlert = true
                }
            } else {
                isShowUpdateAlert = await AppVersionRepository.versionCheck()
                PlayTagRoomRepository.observePublicRooms()
                NoticeRepository.observeNotice()
            }
        }
    }
    func onDisappear() {
        userDataStore.listeners.remove(listenerType: .publicRooms)
        userDataStore.listeners.remove(listenerType: .notice)
    }
}

#Preview {
    PublicRoomsView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, roomDataStore: RoomDataStore.shared)
}
