//
//  SaveButtonSection.swift
//  PUT DOWN THE PHONE
//
//  Created by Marwan Nakhaleh on 6/14/25.
//

import SwiftUI

/// A form section that simply saves the current settings without activating the monitoring schedule.
struct SaveButtonSection: View {
    @EnvironmentObject var settings: SettingsModel

    var body: some View {
        Section {
            Button("Save") {
                // Persist any edits, but keep the schedule inactive.
                settings.isActive = false
                DeviceActivityScheduler.shared.apply(settings: settings)
            }
        }
    }
}
