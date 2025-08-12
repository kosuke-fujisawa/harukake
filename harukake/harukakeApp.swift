//
//  harukakeApp.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI
import UIKit

// MARK: - AppDelegate for orientation control
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // iPhone では横向きのみをサポート
        if UIDevice.current.userInterfaceIdiom == .phone {
            return [.landscapeLeft, .landscapeRight]
        }
        // iPad では全方向をサポート（両ランドスケープ + ポートレート）
        return .all
    }
}

@main
struct HarukakeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppStateObservable()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
