//
//  DeviceActivityMonitorExtension.swift
//  PhoneUsageMonitorExtension
//
//  Created by Marwan Nakhaleh on 5/30/25.
//

import DeviceActivity
import UserNotifications
import Foundation
// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        // When the user has used the device for the configured `intervalMinutes`
        // threshold, fire a local notification with a random angry phrase.

        // Fetch the latest angry phrases array – the main app stores this in
        // UserDefaults (simple but effective for an app-group-less sample).
        let dfPhrases: [String] = [
            "Hey, it's time to put your phone down.",
            "Seriously, stop scrolling.",
            "PUT. IT. DOWN.",
            "You're still on your phone? Knock it off.",
            "Keep using your phone if you're a dumbass.",
            "That's it, go to sleep!"
        ]

        let phrases = UserDefaults.standard.stringArray(forKey: "angryReminders.angerPhrases") ?? dfPhrases
        guard let body = phrases.randomElement() else { return }

        // Craft the notification content.
        let content = UNMutableNotificationContent()
        content.title = "PUT DOWN THE PHONE"
        content.body  = body
        content.sound = UNNotificationSound.default

        // Deliver immediately.
        let request = UNNotificationRequest(
            identifier: "angryRemind-\(UUID().uuidString)",
            content: content,
            trigger: nil // immediately
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("⚠️ Failed to schedule angry reminder notification:", error)
            } else {
                print("📣 Angry reminder notification scheduled → \(body)")
            }
        }
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
