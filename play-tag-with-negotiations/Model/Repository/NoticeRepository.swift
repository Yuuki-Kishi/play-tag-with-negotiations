//
//  NoticeRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/12/09.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class NoticeRepository {
//    create
    static func sendInviteNotice(users: Set<User>, roomId: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            for user in users {
                let notice = Notice(senderUserId: myUserId, roomId: roomId)
                let encoded = try! JSONEncoder().encode(notice)
                guard let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else { return }
                try await Firestore.firestore().collection("Users").document(user.userId).collection("Notices").document(notice.noticeId).setData(jsonObject)
            }
        } catch {
            print(error)
        }
    }
    
//    check
    
    
//    get
    
    
//    update
    
    
//    delete
    static func deleteNotice(noticeId: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(myUserId).collection("Notices").document(noticeId).delete()
        } catch {
            print(error)
        }
    }
    
    static func deleteAllNotice() async {
        let notices = UserDataStore.shared.noticeArray
        for notice in notices {
            await deleteNotice(noticeId: notice.noticeId)
        }
    }
    
//    observe
    static func observeNotice() {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let listener = Firestore.firestore().collection("Users").document(myUserId).collection("Notices").addSnapshotListener { querySnapshot, error in
            guard let documentChanges = querySnapshot?.documentChanges else { return }
            Task {
                do {
                    for documentChange in documentChanges {
                        let document = documentChange.document
                        var notice = try document.data(as: Notice.self)
                        guard let sendUser = await UserRepository.getUserData(userId: notice.senderUserId) else { return }
                        notice.sendUser = sendUser
                        switch documentChange.type {
                        case .added:
                            DispatchQueue.main.async {
                                UserDataStore.shared.noticeArray.append(noDuplicate: notice)
                                UserDataStore.shared.noticeArray.sort { $0.sendDate > $1.sendDate }
                            }
                        case .modified:
                            DispatchQueue.main.async {
                                UserDataStore.shared.noticeArray.append(noDuplicate: notice)
                                UserDataStore.shared.noticeArray.sort { $0.sendDate > $1.sendDate }
                            }
                        case .removed:
                            guard let index = UserDataStore.shared.noticeArray.firstIndex(of: notice) else { return }
                            DispatchQueue.main.async {
                                UserDataStore.shared.noticeArray.remove(at: index)
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.notice] = listener
        }
    }
}
