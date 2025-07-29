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
        let defaultStart = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
        let defaultEnd   = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!
        self.days = symbols.map {
            DaySettings(id: UUID(), weekday: $0, startTime: defaultStart, endTime: defaultEnd) 
        }
        self.vacationMode = false
        self.intervalMinutes = 5
        self.angerPhrases = [
            "Hey, it's time to put your phone down.",
            "Seriously, stop scrolling.",
            "I said: PUT. IT. DOWN!",
            "You're still on your phone? Knock it off.",
            "That's it, go to sleep!"
        ]
        // Monitoring begins in an inactive state by default
        self.isActive = false
    }
}
