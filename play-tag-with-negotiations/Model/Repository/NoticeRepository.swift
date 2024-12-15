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
                try await Firestore.firestore().collection("Users").document(user.userId).collection("Notices").document(notice.noticeId.uuidString).setData(jsonObject)
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
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        do {
            try await Firestore.firestore().collection("Users").document(userId).collection("Notices").document(noticeId).updateData(["isChecked": true])
        } catch {
            print(error)
        }
    }
    
//    delete
    
//    observe
    
}
