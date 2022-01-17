//
//  openTokApp.swift
//  openTok
//
//  Created by HLi on 4/29/21.
//

import SwiftUI
import Firebase
@main
struct assign5App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

}
