//
//  TutorialPublicRoomsView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI
import TipKit

struct TutorialPublicRoomsView: View {
    @ObservedObject var tutorailDataStore: TutorialDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isShowAlert = false
    @State private var roomId = TutorialDataStore.shared.tutorialPlayTagRoom.roomId
    
    var body: some View {
        VStack {
            Spacer()
            Text("チュートリアル画面だよ")
            Spacer()
            HStack {
                Spacer()
                Menu {
                    Button(action: {
                        pathDataStore.navigatetionPath.append(.tutorialRoomSetting)
                    }, label: {
                        Label("ルーム作成", systemImage: "plus")
                    })
                    Button(action: {}, label: {
                        Label("ルームに参加", systemImage: "arrow.right.to.line.compact")
                    })
                } label: {
                    Image(systemName: "figure.run")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.primary)
                        .background(RoundedRectangle(cornerRadius: 25).frame(width: 75, height: 75))
                        .frame(width: 75, height: 75)
                }
                .popoverTip(MakeRoomTip())
                .menuOrder(.fixed)
                .padding(.trailing, 40)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("チュートリアル")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                HStack {
                    Button(action: {}, label: {
                        Image(systemName: "envelope")
                    })
                    Button(action: {}, label: {
                        Image(systemName: "ellipsis.circle")
                    })
                }
            })
            ToolbarItem(placement: .topBarLeading, content: {
                Button(action: {
                    pathDataStore.navigatetionPath.removeAll()
                }, label: {
                    Text("やめる")
                })
            })
        }
        .alert("参加先のルームID", isPresented: $isShowAlert, actions: {
            TextField("ルームID", text: $roomId)
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(action: {
                pathDataStore.navigatetionPath.append(.tutorialWaitingRoom)
            }, label: {
                Text("参加")
            })
        })
        .onAppear() {
            tutorailDataStore.tutorialPlayTagRoom = PlayTagRoom()
            tutorailDataStore.tutorialUserArray.removeAll()
            tutorailDataStore.tutorialPlayerArray.removeAll()
        }
    }
}

#Preview {
    TutorialPublicRoomsView(tutorailDataStore: TutorialDataStore.shared, pathDataStore: PathDataStore.shared)
}
