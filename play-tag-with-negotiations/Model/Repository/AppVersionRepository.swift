//
//  AppVersionRepository.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2025/03/02.
//

import Foundation

class AppVersionRepository {
    static func versionCheck() async -> Bool {
        guard let info = Bundle.main.infoDictionary,
            let appVersion = info["CFBundleShortVersionString"] as? String,
            let url = URL(string: "https://itunes.apple.com/jp/lookup?id=6504573276") else { return false }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else { return false}
            
            switch httpResponse.statusCode {
            case 200:
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any],
                      let storeVersion = result["version"] as? String else { return false }
                if appVersion < storeVersion {
                    return true
                }
            default:
                return false
            }
        } catch let error {
            print(error)
        }
        return false
    }
}
