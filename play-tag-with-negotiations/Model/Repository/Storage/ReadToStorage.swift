//
//  ReadToStorage.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/07.
//

import Foundation
import FirebaseCore
import FirebaseStorage

class ReadToStorage {
    static func getIconImage(iconUrl: String) async {
        if iconUrl == "" { return }
        else {
            let storageRef = Storage.storage().reference(forURL: iconUrl)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print(error)
                }
                else {
                    let imageData: Data? = data
                    UserDataStore.shared.iconImageData = imageData
                }
            }
        }
    }
}