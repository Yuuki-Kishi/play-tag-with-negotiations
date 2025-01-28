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
//    static func getNotice(noticeId: String) async -> Notice? {
//        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return nil }
//        do {
//            let document = try await Firestore.firestore().collection("Users").document(myUserId).collection("Notices").document(noticeId).getDocument()
//            var notice = try document.data(as: Notice.self)
//            guard let sendUser = await getUserData(userId: notice.senderUserId) else { return nil }
//            notice.sendUser = sendUser
//            return notice
//        } catch {
//            print(error)
//        }
//        return nil
//    }
    
//    static func getNonCheckedNotice() async -> [Notice] {
//        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return [] }
//        do {
//            let documents = try await Firestore.firestore().collection("Users").document(myUserId).collection("Notices").whereField("isChecked", isEqualTo: false).getDocuments().documents
//            var notices: [Notice] = []
//            for document in documents {
//                guard let notice = await getNotice(noticeId: document.documentID) else { return [] }
//                notices.append(notice)
//            }
//            return notices
//        } catch {
//            print(error)
//        }
//        return []
//    }
    
//    update
    static func checkNotice(noticeId: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(myUserId).collection("Notices").document(noticeId).updateData(["isChecked": true])
        } catch {
            print(error)
        }
    }
    
    static func allCheckNotice() async {
        let nonCheckNotices = UserDataStore.shared.noticeArray.filter { !$0.isChecked }
        for notice in nonCheckNotices {
            await checkNotice(noticeId: notice.noticeId)
        }
    }
    
//    delete
    static func deleteNotice(noticeId: String) async {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(myUserId).collection("Notices").document(noticeId).delete()
        } catch {
            print(error)
        }
    }
    
//    observe
    static func observeNotice() {
        guard let myUserId = UserDataStore.shared.signInUser?.userId else { return }
        let listener = Firestore.firestore().collection("Users").document(myUserId).collection("Notices").addSnapshotListener { querySnapshot, error in
            guard let documentChanges = querySnapshot?.documentChanges else { return }
            do {
                for documentChange in documentChanges {
                    let document = documentChange.document
                    let notice = try document.data(as: Notice.self)
                    switch documentChange.type {
                    case .added:
                        DispatchQueue.main.async {
                            UserDataStore.shared.noticeArray.append(noDuplicate: notice)
                        }
                    case .modified:
                        DispatchQueue.main.async {
                            UserDataStore.shared.noticeArray.append(noDuplicate: notice)
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
        DispatchQueue.main.async {
            UserDataStore.shared.listeners[UserDataStore.listenerType.notice] = listener
        }
    }
}
