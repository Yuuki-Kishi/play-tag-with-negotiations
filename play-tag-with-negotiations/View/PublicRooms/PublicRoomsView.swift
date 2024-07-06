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
    @State private var playTagRoomsArray: [PlayTagRoom] = []
    @State private var isShowAlert = false
    @State private var isNavigationToRoom = false
    @State private var isNavigationToInvited = false
    @State private var roomId = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                List($playTagRoomsArray) { playTagRoom in
                    PublicRoomsViewCell(playTagRoom: playTagRoom)
                }
                .navigationDestination(for: PlayTagRoom.self) { playTagRoom in
                    
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
                        Task {
                            if await ReadToFirestore.checkIsThereRoom(roomId: roomId) {
                                playerDataStore.playingRoom = await ReadToFirestore.getRoomData(roomId: roomId)
                                await CreateToFirestore.enterRoom(roomId: roomId, isHost: false)
                                isNavigationToRoom = true
                            }
                        }
                    })
                })
                .navigationDestination(isPresented: $isNavigationToRoom, destination: {
                    WaitingRoomView(userDataStore: userDataStore, playerDataStore: playerDataStore)
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
                playTagRoomsArray = []
                playTagRoomsArray.append(PlayTagRoom())
                playTagRoomsArray.append(PlayTagRoom())
            }
        }
    }
    func testPrint() {
        print("Tapped")
    }
    func toolBarMenu() -> some View {
        Menu {
            NavigationLink(destination: RoomSettingView(userDataStore: userDataStore, playerDataStore: playerDataStore), label: {
                Label("ルーム作成", systemImage: "plus")
            })
            NavigationLink(destination: MyPageView(userDataStore: userDataStore), label: {
                Label("マイページ", systemImage: "person.circle")
            })
            Menu {
                Button(action: {playTagRoomsArray.sort {$0.playTagName < $1.playTagName}}, label: {
                    Text("名前昇順")
                })
                Button(action: {playTagRoomsArray.sort {$0.playTagName > $1.playTagName}}, label: {
                    Text("名前降順")
                })
                Button(action: {playTagRoomsArray.sort {$0.phaseNow < $1.phaseNow}}, label: {
                    Text("フェーズ昇順")
                })
                Button(action: {playTagRoomsArray.sort {$0.phaseNow > $1.phaseNow}}, label: {
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
}

#Preview {
    PublicRoomsView(userDataStore: UserDataStore.shared, playerDataStore: PlayerDataStore.shared)
}
