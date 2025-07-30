//
//  SettingsModel.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 6/14/25.
//

import Foundation

class SettingsModel: ObservableObject {
    struct DaySettings: Identifiable, Codable {
        var id: UUID
        var weekday: String
        var startTime: Date
        var endTime: Date
    }

    @Published var days: [DaySettings]
    @Published var vacationMode: Bool
    @Published var intervalMinutes: Int
    @Published var angerPhrases: [String]
    /// Indicates whether the monitoring schedule is currently active
    @Published var isActive: Bool

    init() {
        let symbols = Calendar.current.weekdaySymbols

        // Default values ― used only when nothing has been persisted yet.
        let defaultStart = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
        let defaultEnd   = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!
        let defaultDays: [DaySettings] = symbols.map {
            DaySettings(id: UUID(), weekday: $0, startTime: defaultStart, endTime: defaultEnd)
        }
        let defaultPhrases: [String] = [
            "Hey, it's time to put your phone down.",
            "Seriously, stop scrolling.",
            "I said: PUT. IT. DOWN!",
            "You're still on your phone? Knock it off.",
            "That's it, go to sleep!"
        ]

        // Attempt to pull previously-saved state from UserDefaults.
        let ud = UserDefaults.standard
        if let data = ud.data(forKey: "angryReminders.days"),
           let savedDays = try? JSONDecoder().decode([DaySettings].self, from: data) {
            self.days = savedDays
        } else {
            self.days = defaultDays
        }

        let storedInterval = ud.integer(forKey: "angryReminders.intervalMinutes")
        self.intervalMinutes = storedInterval == 0 ? 5 : storedInterval // default to 5 if not set

        self.angerPhrases = ud.stringArray(forKey: "angryReminders.angerPhrases") ?? defaultPhrases

        self.vacationMode = ud.bool(forKey: "angryReminders.vacationMode")
        self.isActive = ud.bool(forKey: "angryReminders.isActive")
    }
}
