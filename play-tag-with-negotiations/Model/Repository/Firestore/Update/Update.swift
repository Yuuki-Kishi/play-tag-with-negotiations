//
//  Update.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/19.
//

import Foundation
import FirebaseFirestore

class Update {
    static func updateUserName(newName: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).setData(["userName": newName], merge: true)
        } catch {
            print(error)
        }
    }
    
    static func updatePronoun(newPronoun: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).setData(["pronoun": newPronoun], merge: true)
        } catch {
            print(error)
        }
    }
    
    static func updateIconUrl(iconUrl: String) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).setData(["iconUrl": iconUrl], merge: true)
        } catch {
            print(error)
        }
    }
    
    static func playerUpToHost(roomId: String, nextHostUserId: String) async {
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(nextHostUserId).updateData(["isHost": true])
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["hostUserId": nextHostUserId])
        } catch {
            print(error)
        }
    }
    
    static func becomeFriend(friendUserId: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let formatter = ISO8601DateFormatter()
        let time = formatter.string(from: Date())
        do {
            try await Firestore.firestore().collection("Users").document(myUserId).collection("Friends").document(friendUserId).updateData(["isFriend": true, "editedTime": time])
            try await Firestore.firestore().collection("Users").document(friendUserId).collection("Friends").document(myUserId).updateData(["isFriend": true, "editedTime": time])
        } catch {
            print(error)
        }
    }
    
    static func gameStart() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["isPlaying": true])
        } catch {
            print(error)
        }
    }
    
    static func randomInitialPosition() async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let horizontalCount = PlayerDataStore.shared.playingRoom.horizontalCount
        let verticalCount = PlayerDataStore.shared.playingRoom.verticalCount
        let initialX = Int.random(in: 0 ..< horizontalCount)
        let initialY = Int.random(in: 0 ..< verticalCount)
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["move": FieldValue.arrayUnion([["x": initialX, "y": initialY]])])
        } catch {
            print(error)
        }
    }
    
    static func updateMyPosition(x: Int, y: Int) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        await updatePosition(userId: userId, x: x, y: y)
    }
    
    static func updatePosition(userId: String, x: Int, y: Int) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["move": FieldValue.arrayUnion([["x": x, "y": y]]), "isDecided": true])
        } catch {
            print(error)
        }
    }
    
    static func moveToNextPhase() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let phaseMax = PlayerDataStore.shared.playingRoom.phaseMax
        let phaseNow = PlayerDataStore.shared.playingRoom.phaseNow
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["phaseNow": phaseNow + 1])
            if phaseNow == phaseMax {
                await gameEnd()
            }
        } catch {
            print(error)
        }
    }
    
    static func gameEnd() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).updateData(["isEnd": true])
        } catch {
            print(error)
        }
    }
    
    static func isDecidedToFalse() async {
        if !PlayerDataStore.shared.playerArray.me.isCaptured {
            let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
            guard let userId = UserDataStore.shared.signInUser?.userId else { return }
            do {
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isDecided": false, "isCanCapture": true])
            } catch {
                print(error)
            }
            await grantMePoint(howMany: 20)
        }
    }
    
    static func appointmentChaser() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        let chaserNumber = PlayerDataStore.shared.playingRoom.chaserNumber
        let chasers = PlayerDataStore.shared.playerArray.shuffled().prefix(chaserNumber)
        for chaser in chasers {
            do {
                try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(chaser.playerUserId).updateData(["isChaser": true, "isCanCapture": false])
            } catch {
                print(error)
            }
        }
    }
    
    static func wasCaptured() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["isCaptured": true])
        } catch {
            print(error)
        }
    }
    
    static func checkNotices() async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        let notices = await Get.getNonCheckedNotice()
        do {
            for notice in notices {
                try await Firestore.firestore().collection("Users").document(userId).collection("Notices").document(notice.noticeId.uuidString).updateData(["isChecked": true])
            }
        } catch {
            print(error)
        }
    }
    
    static func grantMePoint(howMany: Int) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        await grantPoint(userId: userId, howMany: howMany)
    }
    
    static func grantPoint(userId: String, howMany: Int) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        guard let nowPoint = PlayerDataStore.shared.playerArray.first(where: { $0.playerUserId == userId })?.point else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["point": nowPoint + howMany])
        } catch {
            print(error)
        }
    }
    
    static func confiscateMePoint(howMany: Int) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        await confiscatePoint(userId: userId, howMany: howMany)
    }
    
    static func confiscatePoint(userId: String, howMany: Int) async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        guard let nowPoint = PlayerDataStore.shared.playerArray.first(where: { $0.playerUserId == userId })?.point else { return }
        do {
            try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).updateData(["point": nowPoint - howMany])
        } catch {
            print(error)
        }
    }
}
