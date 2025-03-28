//
//  HintTip.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/13.
//

import Foundation
import TipKit

struct TutorialTip: Tip {
    var title: Text {
        Text("チュートリアル")
    }
    
    var message: Text? {
        Text("チュートリアルで使い方をマスターしよう。")
    }
    
    var image: Image? {
        Image(systemName: "questionmark.circle")
    }
}

struct MakeRoomTip: Tip {
    var title: Text {
        Text("ルーム作成")
    }
    
    var message: Text? {
        Text("鬼ごっこをするルームを作成しよう。")
    }
    
    var displayCount: Int {
        0
    }
    
    var image: Image? {
        Image(systemName: "plus")
    }
}

struct MyPageTip: Tip {
    var title: Text {
        Text("マイページ")
    }
    
    var message: Text? {
        Text("メニューから自分のアイコンやユーザーネームを設定しよう。")
    }
    
    var image: Image? {
        Image(systemName: "person.circle")
    }
}

struct RuleSettingTip: Tip {
    var title: Text {
        Text("ルール設定")
    }
    
    var message: Text? {
        Text("各項目の文字列、トグル、数字を変更して、ルールを調整しよう。")
    }
    
    var image: Image? {
        Image(systemName: "slider.horizontal.3")
    }
}

struct WaitingRoomTip: Tip {
    var title: Text {
        Text("待合室")
    }
    
    var message: Text? {
        Text("ゲームを一緒に遊ぶ人にルームIDを共有してルームに入ってもらおう。\nアプリを閉じるとホストでなくなります。")
    }
    
    var image: Image? {
        Image(systemName: "person.3.fill")
    }
}

struct GameStartTip: Tip {
    var title: Text {
        Text("ゲーム開始")
    }
    
    var message: Text? {
        Text("参加者が全員入室したら、このボタンを押してゲームを始めよう。")
    }
    
    var image: Image? {
        Image(systemName: "play.fill")
    }
}

struct IconTip: Tip {
    var title: Text {
        Text("マップ")
    }
    
    var message: Text? {
        Text("赤いマークが鬼、青いマークが逃げる人。\n色で塗りつぶされたマークが自分だよ。")
    }
    
    var image: Image? {
        Image(systemName: "figure.run.circle")
    }
}

struct SelectionPanelTip: Tip {
    var title: Text {
        Text("操作パネル")
    }
    
    var message: Text? {
        Text("操作パネルから、移動や取引をしたり、相手の情報を見たりしよう。")
    }
    
    var image: Image? {
        Image(systemName: "hand.tap")
    }
}

struct MovePanelTip: Tip {
    var title: Text {
        Text("移動")
    }
    
    var message: Text? {
        Text("矢印ボタンで移動して逃げる人を捕まえよう。")
    }
    
    var image: Image? {
        Image(systemName: "square.grid.3x3.fill")
    }
}

struct DealPanelTip: Tip {
    var title: Text {
        Text("取引")
    }
    
    var message: Text? {
        Text("他のプレイヤーと取引をしてゲームを有利に進めよう。")
    }
    
    var image: Image? {
        Image(systemName: "bubble.left.and.bubble.right.fill")
    }
}

struct PlayerInfoPanelTip: Tip {
    var title: Text {
        Text("プレイヤー情報")
    }
    
    var message: Text? {
        Text("選択したプレイヤーの情報を見て戦略を立てよう。")
    }
    
    var image: Image? {
        Image(systemName: "info.circle.fill")
    }
}

struct FriendShipTip: Tip {
    var title: Text {
        Text("フレンド申請")
    }
    
    var message: Text? {
        Text("紙飛行機マークを押して、フレンド申請を送信しよう。")
    }
    
    var image: Image? {
        Image(systemName: "paperplane.fill")
    }
}
