//
//  AppDelegate.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        writeEmojisDictionary()
        
        return true
    }
    
    
}

extension AppDelegate {
    
    func writeEmojisDictionary() {
        
        if let _ = try? DataManager.fetchEmojis() {
            #if DEBUG
            print("Fetched emojis")
            #endif
        } else {
            #if DEBUG
            print("Create new emojis dictionary")
            #endif
            try? DataManager.writeEmojisDictionary()
        }
        
    }
    
}

