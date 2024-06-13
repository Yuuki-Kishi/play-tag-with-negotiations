//
//  PublicRoomsView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import SwiftUI

struct PublicRoomsView: View {
    @State private var testArray = [PlayTagRoom]()
    @State private var isShowAlert = false
    @State private var roomId = String()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List($testArray) { $playTagRoom in
                    Section {
                        NavigationLink(value: playTagRoom, label: {
                            VStack {
                                Text(playTagRoom.playTagName)
                                    .font(.system(size: 30.0))
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(playTagRoomPhase(playTagRoom: playTagRoom))
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        })
                    }
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
                testArray.append(PlayTagRoom())
                testArray.append(PlayTagRoom())
            }
        }
    }
    func testPrint() {
        print("Tapped")
    }
    func toolBarMenu() -> some View {
        Menu {
            NavigationLink(destination: RoomSettingView(playTagName: "鬼ごっこ"), label: {
                Label("ルーム作成", systemImage: "plus")
            })
            NavigationLink(destination: MyPageView(icon: Image(systemName: "person"), userName: "わて", onePhrase: "しかのこのこのここしたんたん"), label: {
                Label("マイページ", systemImage: "person.circle")
            })
            Menu {
                Button(action: {}, label: {
                    Text("名前昇順")
                })
                Button(action: {}, label: {
                    Text("名前降順")
                })
                Button(action: {}, label: {
                    Text("フェーズ昇順")
                })
                Button(action: {}, label: {
                    Text("フェーズ降順")
                })
            } label: {
                Label("並び替え", systemImage: "arrow.up.arrow.down")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func playTagRoomPhase(playTagRoom: PlayTagRoom) -> String {
        let phaseMax = String(playTagRoom.phaseMax) + "フェーズ"
        let phaseNow = String(playTagRoom.phaseNow) + "フェーズ"
        return phaseNow + " / " + phaseMax
    }
}

#Preview {
    PublicRoomsView()
}
