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
    @State private var isShowAlert = false
    @State private var isNavigationToInvited = false
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
                    case .myPage:
                        MyPageView(userDataStore: userDataStore, pathDataStore: pathDataStore)
                    case .friend:
                        FriendView()
                    case .waitingRoom:
                        WaitingRoomView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
                    case .roomInfo:
                        RoomInfomationView(playerDataStore: playerDataStore)
                    case .game:
                        GameView(userDataStore: userDataStore, playerDataStore: playerDataStore, pathDataStore: pathDataStore)
                    case .result:
                        EmptyView()
                    }
                }
                Button(action: {
                    isShowAlert = true
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 75, height: 75)
                        Image(systemName: "arrow.right.to.line.compact")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.primary)
                    }
                })
                .alert("加入するルームID", isPresented: $isShowAlert, actions: {
                    TextField("ルームID", text: $roomId)
                    Button("キャンセル", role: .cancel, action: {})
                    Button("入室", action: {
                        enterRoom()
                    })
                })
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
                            isNavigationToInvited = true
                        }, label: {
                            Image(systemName: "envelope")
                        })
                        toolBarMenu()
                    }
                })
            }
            .navigationDestination(isPresented: $isNavigationToInvited, destination: {
                
            })
            .onAppear() {
                onAppear()
            }
        }
    }
    func enterRoom() {
        Task {
            if await ReadToFirestore.checkIsThereRoom(roomId: roomId) {
                playerDataStore.playingRoom = await ReadToFirestore.getRoomData(roomId: roomId)
                await CreateToFirestore.enterRoom(roomId: roomId, isHost: false)
                roomId = ""
                pathDataStore.navigatetionPath.append(.waitingRoom)
            }
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                pathDataStore.navigatetionPath.append(.roomSetting)
            }, label: {
                Label("ルーム作成", systemImage: "plus")
            })
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
            if let roomId = await ReadToFirestore.getBeingRoomId() {
                let playingRoom = await ReadToFirestore.getRoomData(roomId: roomId)
                playerDataStore.playingRoom = playingRoom
                if playingRoom.isPlaying {
                    pathDataStore.navigatetionPath.append(.game)
                } else {
                    pathDataStore.navigatetionPath.append(.waitingRoom)
                }
            } else {
                ObserveToFirestore.observePublicRooms()
            }
        }
    }
}

#Preview {
    PublicRoomsView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, roomDataStore: RoomDataStore.shared)
}
