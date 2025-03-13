//
//  HintTip.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/13.
//

import Foundation
import TipKit

struct MakeRoomTip: Tip {
    var title: Text {
        Text("ルーム作成")
    }
    
    var message: Text? {
        Text("ルームを作成して一緒に遊ぶ人を招待しよう。")
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
        Text("自分のアイコンやユーザーネームを設定しよう。")
    }
    
    var image: Image? {
        Image(systemName: "person.circle.fill")
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
        Text("ゲームを一緒に遊ぶ人にルームIDを共有してルームに入ってもらおう。")
    }
    
    var image: Image? {
        Image(systemName: "person.3.fill")
    }
}

struct FriendInviteTip: Tip {
    var title: Text {
        Text("招待状を送信")
    }
    
    var message: Text? {
        Text("ゲームを一緒に遊ぶフレンドに招待状を送信しよう。")
    }
    
    var image: Image? {
        Image(systemName: "paperplane.fill")
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

struct MovePanelTip: Tip {
    var title: Text {
        Text("移動")
    }
    
    var message: Text? {
        Text("60秒以内に次の移動先を指定しよう。")
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
        Text("他のプレイヤーと取引をしよう。取引にはポイントを消費するよ。")
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
        Text("選択したプレイヤーの情報を見よう。")
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
        Text("このボタンを押して、フレンド申請を送信しよう。")
    }
    
    var image: Image? {
        Image(systemName: "paperplane.fill")
    }
}
