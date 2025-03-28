//
//  FightRecordView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/28.
//

import SwiftUI

struct FightRecordView: View {
    @ObservedObject var userDataStore: UserDataStore
    @State private var isShowAllDeleteAlert = false
    @State private var isShowDeleteAlert = false
    
    var body: some View {
        ZStack {
            if !userDataStore.fightRecordArray.isFinished.isEmpty {
                List(userDataStore.fightRecordArray.isFinished) { playedRoom in
                    FightRecordViewCell(playedRoom: Binding(get: { playedRoom }, set: {_ in}))
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive, action: {
                                print("swipe")
                                isShowDeleteAlert = true
                            }, label: {
                                Text("削除")
                            })
                        }
                }
                .alert("戦績を削除しますか？", isPresented: $isShowDeleteAlert, actions: {
                    Button(role: .cancel, action: {}, label: {
                        Text("キャンセル")
                    })
                    Button(role: .destructive, action: {
                        print("delete")
                    }, label: {
                        Text("削除")
                    })
                })
            } else {
                Text("表示できる戦績はありません")
            }
        }
        .navigationTitle("戦績")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    isShowAllDeleteAlert = true
                }, label: {
                    Image(systemName: "trash.fill")
                })
            })
        }
        .alert("本当に削除しますか？", isPresented: $isShowAllDeleteAlert, actions: {
            Button(role: .destructive, action: {
                Task { await PlayedRoomRepository.deletePlayedRooms() }
            }, label: {
                Text("削除")
            })
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
        }, message: {
            Text("全ての戦績が削除されます。この操作は取り消すことができません。")
        })
        .onAppear() {
            Task { await PlayedRoomRepository.getPlayedRooms() }
        }
    }
}

#Preview {
    FightRecordView(userDataStore: UserDataStore.shared)
}
