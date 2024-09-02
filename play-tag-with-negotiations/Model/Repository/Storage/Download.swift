//
//  ReadToStorage.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/07/07.
//

import Foundation
import FirebaseCore
import FirebaseStorage

class Download {
    static func getIconImage(iconUrl: String) async -> Data? {
        if iconUrl == "default" {
            return nil
        } else {
            let imageRef = Storage.storage().reference(forURL: iconUrl)
            let imageData = try? await imageRef.data(maxSize: 1 * 1024 * 1024)
            return imageData
        }
    }
}
