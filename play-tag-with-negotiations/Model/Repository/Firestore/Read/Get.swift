//
//  Get.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/09/01.
//

import Foundation
import FirebaseFirestore

class Get {
    static func getBeingRoomId() async -> String? {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return nil }
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            guard let beingRoomId = document.get("beingRoomId") as? String else { return nil }
            guard let roomId = UUID(uuidString: beingRoomId) else { return nil }
            DispatchQueue.main.async {
                PlayerDataStore.shared.playingRoom.roomId = roomId
            }
            return beingRoomId
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getUserData(userId: String) async -> User? {
        do {
            let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
            let friendsDocuments = try await Firestore.firestore().collection("Users").document(userId).collection("Friends").whereField("isFriend", isEqualTo: true).getDocuments().documents
            if document.exists {
                var friendsUserId: [String] = []
                for friendsDocument in friendsDocuments {
                    friendsUserId.append(friendsDocument.documentID)
                }
                var user = try document.data(as: User.self)
                user.iconData = await Download.getIconImage(iconUrl: user.iconUrl)
                user.friendsUserId = friendsUserId
                return user
            } else {
                return nil
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getNotice(noticeId: String) async -> Notice? {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return nil }
        do {
            let document = try await Firestore.firestore().collection("Users").document(myUserId).collection("Notices").document(noticeId).getDocument()
            var notice = try document.data(as: Notice.self)
            guard let sendUser = await getUserData(userId: notice.senderUserId) else { return nil }
            notice.sendUser = sendUser
            return notice
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getNonCheckedNotice() async -> [Notice] {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
        do {
            let documents = try await Firestore.firestore().collection("Users").document(myUserId).collection("Notices").whereField("isChecked", isEqualTo: false).getDocuments().documents
            var notices: [Notice] = []
            for document in documents {
                guard let notice = await getNotice(noticeId: document.documentID) else { return [] }
                notices.append(notice)
            }
            return notices
        } catch {
            print(error)
        }
        return []
    }
    
    static func getPlayer(userId: String) async -> Player? {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").document(userId).getDocument()
            let player = try document.data(as: Player.self)
            return player
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getAllPlayers() async -> [Player] {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        do {
            let documents = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").getDocuments().documents
            var players: [Player] = []
            for document in documents {
                let player = try document.data(as: Player.self)
                players.append(noDuplicate: player)
            }
            return players
        } catch {
            print(error)
        }
        return []
    }
    
    static func getAlivePlayers() async {
        let players = await getAllPlayers().filter { $0.isCaptured == false }
        let alivePlayers = OperationPlayers.getAlivePlayers(players: players)
        let isAlive = OperationPlayers.isAlive(players: players)
        if !isAlive { await Update.wasCaptured() }
        DispatchQueue.main.async {
            PlayerDataStore.shared.playerArray = []
        }
        for alivePlayer in alivePlayers {
            DispatchQueue.main.async {
                PlayerDataStore.shared.playerArray.append(noDuplicate: alivePlayer)
            }
        }
        let aliveFugitiveCount = OperationPlayers.getAliveFugitives(players: players).count
        if aliveFugitiveCount == 0 {
            await Update.gameEnd()
        }
    }
    
    static func getRoomData(roomId: String) async -> PlayTagRoom? {
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).getDocument()
            let playTagRoom = try document.data(as: PlayTagRoom.self)
            return playTagRoom
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getNegotiation(negotiationId: String) async -> Negotiation? {
        do {
            let document = try await Firestore.firestore().collection("Negotiations").document(negotiationId).getDocument()
            let negotiation = try document.data(as: Negotiation.self)
            return negotiation
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getNegotiations() async {
        do {
            guard let version = Double(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String) else { return }
            let documents = try await Firestore.firestore().collection("Negotiations").whereField("version", isLessThanOrEqualTo: version).getDocuments().documents
            DispatchQueue.main.async {
                PlayerDataStore.shared.negotiationArray = []
            }
            for document in documents {
                let negotiation = try document.data(as: Negotiation.self)
                DispatchQueue.main.async {
                    PlayerDataStore.shared.negotiationArray.append(noDuplicate: negotiation)
                }
            }
        } catch {
            print(error)
        }
    }
    
    static func getResult() async {
        let roomId = PlayerDataStore.shared.playingRoom.roomId.uuidString
        DispatchQueue.main.async {
            PlayerDataStore.shared.playerArray = []
        }
        do {
            let documents = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").getDocuments().documents
            for document in documents {
                let player = try document.data(as: Player.self)
                DispatchQueue.main.async {
                    PlayerDataStore.shared.playerArray.append(noDuplicate: player)
                }
            }
            DispatchQueue.main.async {
                PlayerDataStore.shared.playerArray.sort { $0.point > $1.point }
            }
        } catch {
            print(error)
        }
    }
}
