//
//  FirstLaunchManager.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 5/30/25.
//

import Foundation

class FirstLaunchManager {
    private static let firstLaunchKey = "hasLaunchedBefore"
    
    static var isFirstLaunch: Bool {
        return !UserDefaults.standard.bool(forKey: firstLaunchKey)
    }
    
    static func markFirstLaunchCompleted() {
        UserDefaults.standard.set(true, forKey: firstLaunchKey)
    }
    
    static func resetFirstLaunchFlag() {
        UserDefaults.standard.removeObject(forKey: firstLaunchKey)
    }
} 
