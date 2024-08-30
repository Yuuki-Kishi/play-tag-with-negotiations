//
//  Read.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ReadToFirestore {
    static func isWroteUser(userId: String) async -> Bool {
        do {
            let userDocuments = try await Firestore.firestore().collection("Users").whereField("userId", isEqualTo: userId).getDocuments()
            for userDocument in userDocuments.documents {
                if userDocument.documentID == userId { return true }
            }
            return false
        } catch {
            print("Error getting document: \(error)")
            return true
        }
    }
    
    static func isBeingRoom(roomId: String) async -> Bool {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return true }
        do {
            let players = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").whereField("userId", isEqualTo: userId).getDocuments()
            if players.isEmpty { return false }
        } catch {
            print(error)
        }
        return true
    }
    
    static func getBeingRoomId() async -> String? {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return nil }
        do {
            let userDocument = try await Firestore.firestore().collection("Users").document(userId).getDocument().data()
            guard let beingRoomId = userDocument?["beingRoomId"] as? String else { return nil }
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
                var friendsId: [String] = []
                for friendsDocument in friendsDocuments {
                    friendsId.append(friendsDocument.documentID)
                }
                let document = try await Firestore.firestore().collection("Users").document(userId).getDocument()
                var user = try document.data(as: User.self)
                user.iconData = await ReadToStorage.getIconImage(iconUrl: user.iconUrl)
                user.friendsId = friendsId
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
    
    static func isRecieveRequest(from: String) async -> Bool {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return false }
        do {
            let document = try await Firestore.firestore().collection("Users").document(myUserId).collection("Friends").whereField("pertnerUserId", isEqualTo: from).getDocuments().documents
            if !document.isEmpty {
                return true
            }
        } catch {
            print(error)
        }
        return false
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
                players.append(ifNoOverlap: player)
            }
            return players
        } catch {
            print(error)
            return []
        }
    }
    
    static func getAlivePlayers() async {
        let players = await getAllPlayers().filter { $0.isCaptured == false }
        let alivePlayers = OperationPlayers.getAlivePlayers(players: players)
        let isAlive = OperationPlayers.isAlive(players: players)
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        guard var myPlayerData = await getPlayer(userId: myUserId) else { return }
        if !isAlive {
            myPlayerData.isCaptured = true
            await UpdateToFirestore.wasCaptured()
        }
        DispatchQueue.main.async {
            PlayerDataStore.shared.player = myPlayerData
            
            PlayerDataStore.shared.guestUserArray = []
            PlayerDataStore.shared.guestPlayerArray = []
            PlayerDataStore.shared.userArray = []
            PlayerDataStore.shared.playerArray = []
        }
        for alivePlayer in alivePlayers {
            guard let user = await ReadToFirestore.getUserData(userId: alivePlayer.userId) else { return }
            if alivePlayer.isHost {
                DispatchQueue.main.async {
                    PlayerDataStore.shared.hostUser = user
                    PlayerDataStore.shared.hostPlayer = alivePlayer
                }
            } else {
                DispatchQueue.main.async {
                    PlayerDataStore.shared.guestUserArray.append(ifNoOverlap: user)
                    PlayerDataStore.shared.guestPlayerArray.append(ifNoOverlap: alivePlayer)
                }
            }
            DispatchQueue.main.async {
                PlayerDataStore.shared.userArray.append(ifNoOverlap: user)
                PlayerDataStore.shared.playerArray.append(ifNoOverlap: alivePlayer)
            }
        }
        if PlayerDataStore.shared.player.isHost {
            let aliveFugitiveCount = OperationPlayers.getAliveFugitives(players: players).count
            if aliveFugitiveCount == 0 {
                await UpdateToFirestore.gameEnd()
            }
        }
        await UpdateToFirestore.isDecidedToFalse()
    }
    
    static func checkIsThereRoom(roomId: String) async -> Bool {
        do {
            let playTagRooms = try await Firestore.firestore().collection("PlayTagRooms").getDocuments()
            for playTagRoom in playTagRooms.documents {
                if playTagRoom.documentID == roomId { return true }
            }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    static func isNotOverPlayer(roomId: String) async -> Bool {
        do {
            let playersCount = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).collection("Players").getDocuments().count
            let playTagRoom = await getRoomData(roomId: roomId)
            let playingPlayerCount = playTagRoom.chaserNumber + playTagRoom.fugitiveNumber
            if playersCount < playingPlayerCount {
                return true
            }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    static func getRoomData(roomId: String) async -> PlayTagRoom {
        do {
            let document = try await Firestore.firestore().collection("PlayTagRooms").document(roomId).getDocument()
            let playTagRoom = try document.data(as: PlayTagRoom.self)
            return playTagRoom
        } catch {
            print(error)
        }
        return PlayTagRoom()
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
                    PlayerDataStore.shared.negotiationArray.append(ifNoOverlap: negotiation)
                }
            }
        } catch {
            print(error)
        }
    }
    
    static func getResult() async {
        let allPlayers = await getAllPlayers()
        var allUsers: [User] = []
        for player in allPlayers {
            guard let user = await getUserData(userId: player.userId) else { return }
            allUsers.append(ifNoOverlap: user)
        }
        DispatchQueue.main.async {
            PlayerDataStore.shared.userArray = []
            PlayerDataStore.shared.playerArray = []
            PlayerDataStore.shared.userArray = allUsers
            PlayerDataStore.shared.playerArray = allPlayers
        }
    }
}
