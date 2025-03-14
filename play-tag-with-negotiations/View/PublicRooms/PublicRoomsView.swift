//
//  PublicRoomsView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import SwiftUI
import TipKit

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
                if !roomDataStore.publicRoomsArray.isEmpty {
                    List(roomDataStore.publicRoomsArray) { playTagRoom in
                        PublicRoomsViewCell(playerDataStore: playerDataStore, pathDataStore: pathDataStore, playTagRoom: playTagRoom)
                    }
                } else {
                    Spacer()
                    Text("公開中のルームはありません")
                    Spacer()
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
                    HStack {
                        TipView(MakeRoomTip(), arrowEdge: .trailing)
                            .padding(.horizontal)
                        Image(systemName: "figure.run")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.primary)
                            .background(RoundedRectangle(cornerRadius: 25).frame(width: 75, height: 75))
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                }
                .menuOrder(.fixed)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 35)
                .padding(.bottom, 35)
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
                }
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
            .alert("参加先のするルームID", isPresented: $isShowEnterRoomAlert, actions: {
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
            let isThereRoom = await PlayTagRoomRepository.isExists(roomId: roomId)
            let isOverPlayer = await PlayTagRoomRepository.isOverPlayerCount(roomId: roomId)
            if isThereRoom {
                if !isOverPlayer {
                    guard let playingRoom = await PlayTagRoomRepository.getRoomData(roomId: roomId) else { return }
                    DispatchQueue.main.async {
                        playerDataStore.playingRoom = playingRoom
                    }
                    await PlayerRepository.enterRoom(roomId: roomId, isHost: false)
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
                Label("マイページ", systemImage: "person.circle.fill")
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
        .popoverTip(MyPageTip(), arrowEdge: .bottom)
    }
    func onAppear() {
        Task {
            if let roomId = await UserRepository.getBeingRoomId() {
                guard let playingRoom = await PlayTagRoomRepository.getRoomData(roomId: roomId) else { return }
                DispatchQueue.main.async {
                    playerDataStore.playingRoom = playingRoom
                }
                if playingRoom.playerNumber >= playingRoom.fugitiveNumber + playingRoom.chaserNumber {
                    isShowOverPlayerAlert = true
                    await UserRepository.finishGame()
                } else {
                    if playingRoom.isPlaying {
                        if playingRoom.isFinished {
                            await UserRepository.finishGame()
                        } else {
                            await UserRepository.getUsersData()
                            await PlayerRepository.getAlivePlayers(phaseNow: playingRoom.phaseNow)
                            DispatchQueue.main.async {
                                pathDataStore.navigatetionPath.append(.game)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            pathDataStore.navigatetionPath.append(.waitingRoom)
                        }
                    }
                }
            } else {
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
