//
//  TutorialWaitingRoomView.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/18.
//

import SwiftUI
import TipKit

struct TutorialWaitingRoomView: View {
    @ObservedObject var tutorialDataStore: TutorialDataStore
    @ObservedObject var pathDataStore: PathDataStore
    
    var body: some View {
        ZStack {
            VStack {
                TipView(WaitingRoomTip())
                    .padding(.horizontal)
                List {
                    Section(content: {
                        TutorialWaitingRoomViewCell(tutorialDataStore: tutorialDataStore, userId: Binding(get: { tutorialDataStore.tutorialPlayerArray.me.playerUserId }, set: {_ in}))
                    }, header: {
                        Text("ホスト")
                    })
                    Section(content: {
                        ForEach(tutorialDataStore.tutorialPlayerArray.guests, id: \.playerUserId) { player in
                            TutorialWaitingRoomViewCell(tutorialDataStore: tutorialDataStore, userId: Binding(get: { player.playerUserId }, set: {_ in}))
                        }
                    }, header: {
                        Text("ゲスト")
                    })
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        tutorialDataStore.tutorialPlayTagRoom.phaseNow = 1
                        tutorialDataStore.tutorialPlayTagRoom.isPlaying = true
                    }, label: {
                        Image(systemName: "play.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.primary)
                            .background(RoundedRectangle(cornerRadius: 25).frame(width: 75, height: 75))
                            .frame(width: 75, height: 75)
                    })
                    .popoverTip(GameStartTip())
                    .padding(.trailing, 40)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle("待合室")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onChange(of: tutorialDataStore.tutorialPlayTagRoom.isPlaying) {
            if tutorialDataStore.tutorialPlayTagRoom.isPlaying {
                tutorialDataStore.initPosition()
                tutorialDataStore.initNegotiationArrayAndDealArray()
                pathDataStore.navigatetionPath.append(.tutorialGame)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {}, label: {
                    Image(systemName: "ellipsis.circle")
                })
            })
        }
        .onAppear() {
            tutorialDataStore.initUserArrayAndPlayerArray()
        }
    }
}

#Preview {
    TutorialWaitingRoomView(tutorialDataStore: TutorialDataStore.shared, pathDataStore: PathDataStore.shared)
}
