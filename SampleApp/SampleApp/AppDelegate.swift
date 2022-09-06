//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Alireza Asadi on 15/6/1401 AP.
//

import UIKit
import MapirMapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "MapirAPIKey") as? String {
            MapirAccountManager.shared.set(apiKey: apiKey)
        } else {
            print(#"You need to specify a Map.ir API key in the bottom function. If you don't have one, please checkout "https://help-mapir.imber.ir/fa/post/60963c70c156fb9c4d587a1b""#)
            // MapirAccountManager.shared.set(apiKey: <YOUR_API_KEY>)
        }

        MapirMapKit.registerHTTPService()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

