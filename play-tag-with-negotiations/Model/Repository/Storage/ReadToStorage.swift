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
    static func getMyIconImage(iconUrl: String) async {
        if iconUrl == "default" { return }
        else {
            let storageRef = Storage.storage().reference(forURL: iconUrl)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print(error)
                } else {
                    let imageData: Data? = data
                    UserDataStore.shared.iconImageData = imageData
                }
            }
        }
    }
    
    static func getPlayerIconImage(iconUrl: String) async -> Data? {
        if iconUrl == "default" { return Data() }
        else {
            let storageRef = Storage.storage().reference(forURL: iconUrl)
            var imageData: Data? = Data()
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print(error)
                } else {
                    imageData = data
                }
            }
            return imageData
        }
    }
}
