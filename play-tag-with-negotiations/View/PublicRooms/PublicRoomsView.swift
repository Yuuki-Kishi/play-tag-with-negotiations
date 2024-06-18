//
//  PublicRoomsView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import SwiftUI

struct PublicRoomsView: View {
    @ObservedObject var userDataStore: UserDataStore
    @State private var playTagRoomsArray = [PlayTagRoom]()
    @State private var isShowAlert = false
    @State private var roomId = String()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List($playTagRoomsArray) { playTagRoom in
                    PublicRoomsCellView(playTagRoom: playTagRoom)
                }
                .navigationDestination(for: PlayTagRoom.self) { playTagRoom in
                    
                }
                Button(action: {
                    isShowAlert = true
                    testPrint()
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
                        print(roomId)
                    })
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 35)
            }
            .navigationTitle("公開中")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    toolBarMenu()
                })
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
            NavigationLink(destination: RoomSettingView(), label: {
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
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

#Preview {
    PublicRoomsView(userDataStore: UserDataStore.shared)
}
