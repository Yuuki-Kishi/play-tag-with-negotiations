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
    @ObservedObject var roomDataStore: RoomDataStore
    @State private var isShowAlert = false
    @State private var isNavigationToWaitingRoomView = false
    @State private var isNavigationToRoomSettingView = false
    @State private var isNavigationToInvited = false
    @State private var roomId = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var envData: EnvironmentData
    
    var body: some View {
        NavigationStack {
            ZStack {
                List($roomDataStore.publicRoomsArray) { $playTagRoom in
                    PublicRoomsViewCell(playTagRoom: $playTagRoom)
                        .onTapGesture {
                            let roomId = playTagRoom.roomId.uuidString
                            Task {
                                if await ReadToFirestore.checkIsThereRoom(roomId: roomId) {
                                    playerDataStore.playingRoom = await ReadToFirestore.getRoomData(roomId: roomId)
                                    await CreateToFirestore.enterRoom(roomId: roomId, isHost: false)
                                    isNavigationToWaitingRoomView = true
//                                    envData.isNavigationFromPublicRoomsView = $isNavigationToWaitingRoomView
                                }
                            }
                        }
                }
                .navigationDestination(isPresented: $isNavigationToWaitingRoomView, destination: {
                    WaitingRoomView(userDataStore: userDataStore, playerDataStore: playerDataStore)
                })
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
                        Task {
                            if await ReadToFirestore.checkIsThereRoom(roomId: roomId) {
                                playerDataStore.playingRoom = await ReadToFirestore.getRoomData(roomId: roomId)
                                await CreateToFirestore.enterRoom(roomId: roomId, isHost: false)
                                isNavigationToWaitingRoomView = true
//                                envData.isNavigationFromPublicRoomsView = $isNavigationToWaitingRoomView
                            }
                        }
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
            .onChange(of: userDataStore.signInUser) {
                if userDataStore.signInUser == nil {
                    dismiss()
                }
            }
            .onAppear() {
                Task {
                    if let roomId = await ReadToFirestore.getBeingRoomId() {
                        playerDataStore.playingRoom = await ReadToFirestore.getRoomData(roomId: roomId)
                        isNavigationToWaitingRoomView = true
//                        envData.isNavigationFromPublicRoomsView = $isNavigationToWaitingRoomView
                    } else {
                        ObserveToFirestore.observePublicRooms()
                    }
                }
            }
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                isNavigationToRoomSettingView = true
//                envData.isNavigationFromPublicRoomsView = $isNavigationToRoomSettingView
            }, label: {
                Label("ルーム作成", systemImage: "plus")
            })
            NavigationLink(destination: MyPageView(userDataStore: userDataStore), label: {
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
        .navigationDestination(isPresented: $isNavigationToRoomSettingView, destination: {
            RoomSettingView(userDataStore: userDataStore, playerDataStore: playerDataStore)
        })
    }
}

#Preview {
    PublicRoomsView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared, roomDataStore: RoomDataStore.shared)
}
