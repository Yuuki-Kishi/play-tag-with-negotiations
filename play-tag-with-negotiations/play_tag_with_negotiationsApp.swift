//
//  play_tag_with_negotiationsApp.swift
//  play-tag-with-negotiations
//
//  Created by 岸　優樹 on 2024/06/10.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import TipKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
//    func applicationWillTerminate(_ application: UIApplication) {
//        if PlayerDataStore.shared.playerArray.me.isHost {
//            Task { await PlayerRepository.hostExitRoom() }
//        } else {
//            Task { await PlayerRepository.exitRoom() }
//        }
//    }
}

@main
struct play_tag_with_negotiationsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        try? Tips.resetDatastore()
        try? Tips.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
