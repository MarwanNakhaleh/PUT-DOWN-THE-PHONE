//
//  IntervalSection.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 6/14/25.
//


import SwiftUI

struct IntervalSection: View {
    @EnvironmentObject var settings: SettingsModel

    var body: some View {
        Section(header: Text("Interval (minutes)")) {
            Stepper(value: $settings.intervalMinutes, in: 1...60) {
                Text("Every \(settings.intervalMinutes) minutes")
            }
        }
    }
}