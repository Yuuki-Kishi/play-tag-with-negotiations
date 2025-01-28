//
//  Create.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/06.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseCore
import FirebaseStorage

class Upload {
    static func uploadIconImage(selectedItem: PhotosPickerItem?) async {
        guard let userId = UserDataStore.shared.signInUser?.userId else { return }
        guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
        guard let image = UIImage(data: data) else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        let storageRef = Storage.storage().reference().child(userId).child("icon.jpg")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error { print(error) }
            else {
                storageRef.downloadURL { (url, error) in
                    Task {
                        guard let iconUrl = url?.absoluteString else { return }
                        await UserRepository.updateIconUrl(iconUrl: iconUrl)
                    }
                }
            }
        }
    }
}
