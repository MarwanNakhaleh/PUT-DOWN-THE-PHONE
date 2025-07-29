//
//  Main.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 6/14/25.
//

import SwiftUI
import FamilyControls
import DeviceActivity

@main
struct AngryPhoneReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var settings = SettingsModel()

    var body: some Scene {
        WindowGroup {
            SettingsView()
                .environmentObject(settings)
        }
    }
}
